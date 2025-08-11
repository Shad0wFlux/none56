import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  ActivityIndicator,
  ScrollView,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { InstagramAPI } from '../utils/InstagramAPI';

interface CheckpointScreenProps {
  challengePath: string;
  api: InstagramAPI;
  onLoginSuccess: (sessionInfo: any) => void;
  onBack: () => void;
}

const CheckpointScreen: React.FC<CheckpointScreenProps> = ({ 
  challengePath, 
  api, 
  onLoginSuccess, 
  onBack 
}) => {
  const [loading, setLoading] = useState(false);
  const [step, setStep] = useState<'method' | 'choice' | 'code'>('method');
  const [verificationMethod, setVerificationMethod] = useState<{
    method: string;
    contact: string;
    message: string;
  } | null>(null);
  const [choice, setChoice] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [contactPoint, setContactPoint] = useState('');

  useEffect(() => {
    handleCheckpoint();
  }, []);

  const handleCheckpoint = async () => {
    setLoading(true);
    try {
      const result = await api.handleCheckpoint(challengePath);
      
      if (result.success) {
        setVerificationMethod(result);
        setStep('choice');
      } else {
        Alert.alert('خطأ', result.message);
      }
    } catch (error: any) {
      Alert.alert('خطأ', `حدث خطأ: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleSendChoice = async () => {
    if (!choice.trim()) {
      Alert.alert('خطأ', 'يرجى إدخال اختيارك');
      return;
    }

    setLoading(true);
    try {
      const result = await api.sendChoice(challengePath, choice.trim());
      
      if (result.success) {
        setContactPoint(result.contactPoint);
        setStep('code');
        Alert.alert('تم', result.message);
      } else {
        Alert.alert('خطأ', result.message);
      }
    } catch (error: any) {
      Alert.alert('خطأ', `حدث خطأ: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleSendCode = async () => {
    if (!verificationCode.trim()) {
      Alert.alert('خطأ', 'يرجى إدخال كود التحقق');
      return;
    }

    setLoading(true);
    try {
      const result = await api.sendVerificationCode(challengePath, verificationCode.trim());
      
      if (result.success) {
        Alert.alert('نجح', result.message, [
          {
            text: 'موافق',
            onPress: () => onLoginSuccess(api.getSessionInfo())
          }
        ]);
      } else {
        Alert.alert('خطأ', result.message, [
          {
            text: 'إعادة المحاولة',
            onPress: () => {
              setVerificationCode('');
              setLoading(false);
            }
          },
          {
            text: 'العودة',
            onPress: onBack
          }
        ]);
      }
    } catch (error: any) {
      Alert.alert('خطأ', `حدث خطأ: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const renderMethodStep = () => (
    <View style={styles.stepContainer}>
      <Text style={styles.stepTitle}>جاري تحميل معلومات التحقق...</Text>
      <ActivityIndicator size="large" color="#E4405F" />
    </View>
  );

  const renderChoiceStep = () => (
    <View style={styles.stepContainer}>
      <Text style={styles.stepTitle}>اختر طريقة التحقق</Text>
      
      {verificationMethod && (
        <View style={styles.methodInfo}>
          <Text style={styles.methodText}>{verificationMethod.message}</Text>
          <Text style={styles.instructionText}>
            {verificationMethod.method === 'phone' 
              ? 'اكتب 0 للتحقق عبر الهاتف' 
              : 'اكتب 1 للتحقق عبر البريد الإلكتروني'
            }
          </Text>
        </View>
      )}

      <View style={styles.inputContainer}>
        <Text style={styles.label}>اختيارك</Text>
        <TextInput
          style={styles.input}
          placeholder={verificationMethod?.method === 'phone' ? '0' : '1'}
          value={choice}
          onChangeText={setChoice}
          keyboardType="numeric"
          maxLength={1}
          editable={!loading}
        />
      </View>

      <TouchableOpacity
        style={[styles.button, loading && styles.buttonDisabled]}
        onPress={handleSendChoice}
        disabled={loading}
      >
        {loading ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <Text style={styles.buttonText}>إرسال الاختيار</Text>
        )}
      </TouchableOpacity>
    </View>
  );

  const renderCodeStep = () => (
    <View style={styles.stepContainer}>
      <Text style={styles.stepTitle}>أدخل كود التحقق</Text>
      
      {contactPoint && (
        <View style={styles.methodInfo}>
          <Text style={styles.methodText}>تم إرسال الكود إلى: {contactPoint}</Text>
        </View>
      )}

      <View style={styles.inputContainer}>
        <Text style={styles.label}>كود التحقق</Text>
        <TextInput
          style={styles.input}
          placeholder="أدخل الكود المرسل إليك"
          value={verificationCode}
          onChangeText={setVerificationCode}
          keyboardType="numeric"
          maxLength={6}
          editable={!loading}
        />
      </View>

      <TouchableOpacity
        style={[styles.button, loading && styles.buttonDisabled]}
        onPress={handleSendCode}
        disabled={loading}
      >
        {loading ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <Text style={styles.buttonText}>تأكيد الكود</Text>
        )}
      </TouchableOpacity>
    </View>
  );

  return (
    <KeyboardAvoidingView 
      style={styles.container} 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.headerContainer}>
          <Text style={styles.title}>تحدي الأمان</Text>
          <Text style={styles.subtitle}>Instagram Security Challenge</Text>
        </View>

        {step === 'method' && renderMethodStep()}
        {step === 'choice' && renderChoiceStep()}
        {step === 'code' && renderCodeStep()}

        <TouchableOpacity style={styles.backButton} onPress={onBack}>
          <Text style={styles.backButtonText}>العودة لتسجيل الدخول</Text>
        </TouchableOpacity>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 20,
  },
  headerContainer: {
    alignItems: 'center',
    marginBottom: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#E4405F',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
  },
  stepContainer: {
    marginBottom: 30,
  },
  stepTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#333',
    textAlign: 'center',
    marginBottom: 20,
  },
  methodInfo: {
    backgroundColor: '#f0f8ff',
    padding: 15,
    borderRadius: 8,
    marginBottom: 20,
    borderLeftWidth: 4,
    borderLeftColor: '#E4405F',
  },
  methodText: {
    fontSize: 16,
    color: '#333',
    textAlign: 'right',
    marginBottom: 8,
  },
  instructionText: {
    fontSize: 14,
    color: '#666',
    textAlign: 'right',
    fontStyle: 'italic',
  },
  inputContainer: {
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 8,
    textAlign: 'right',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 15,
    fontSize: 16,
    backgroundColor: '#f9f9f9',
    textAlign: 'center',
  },
  button: {
    backgroundColor: '#E4405F',
    borderRadius: 8,
    padding: 15,
    alignItems: 'center',
    marginTop: 10,
  },
  buttonDisabled: {
    backgroundColor: '#ccc',
  },
  buttonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  backButton: {
    backgroundColor: '#6c757d',
    borderRadius: 8,
    padding: 12,
    alignItems: 'center',
    marginTop: 20,
  },
  backButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default CheckpointScreen;

