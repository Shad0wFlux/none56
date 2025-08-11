import React, { useState } from 'react';
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

interface LoginScreenProps {
  onLoginSuccess: (sessionInfo: any) => void;
  onCheckpointRequired: (challengePath: string, api: InstagramAPI) => void;
}

const LoginScreen: React.FC<LoginScreenProps> = ({ onLoginSuccess, onCheckpointRequired }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [api] = useState(new InstagramAPI());

  const handleLogin = async () => {
    if (!username.trim() || !password.trim()) {
      Alert.alert('خطأ', 'يرجى إدخال اسم المستخدم وكلمة المرور');
      return;
    }

    setLoading(true);
    
    try {
      const result = await api.login(username.trim(), password);
      
      if (result.success) {
        Alert.alert('نجح', result.message, [
          {
            text: 'موافق',
            onPress: () => onLoginSuccess(api.getSessionInfo())
          }
        ]);
      } else if (result.requiresCheckpoint) {
        Alert.alert('تحدي الأمان', result.message, [
          {
            text: 'متابعة',
            onPress: () => onCheckpointRequired(result.challengePath, api)
          }
        ]);
      } else {
        Alert.alert('خطأ', result.message, [
          {
            text: 'إعادة المحاولة',
            onPress: () => setLoading(false)
          }
        ]);
      }
    } catch (error: any) {
      Alert.alert('خطأ', `حدث خطأ غير متوقع: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView 
      style={styles.container} 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.headerContainer}>
          <Text style={styles.title}>Instagram Login</Text>
          <Text style={styles.subtitle}>تسجيل الدخول إلى Instagram</Text>
        </View>

        <View style={styles.formContainer}>
          <View style={styles.inputContainer}>
            <Text style={styles.label}>اسم المستخدم</Text>
            <TextInput
              style={styles.input}
              placeholder="أدخل اسم المستخدم"
              value={username}
              onChangeText={setUsername}
              autoCapitalize="none"
              autoCorrect={false}
              editable={!loading}
            />
          </View>

          <View style={styles.inputContainer}>
            <Text style={styles.label}>كلمة المرور</Text>
            <TextInput
              style={styles.input}
              placeholder="أدخل كلمة المرور"
              value={password}
              onChangeText={setPassword}
              secureTextEntry
              autoCapitalize="none"
              autoCorrect={false}
              editable={!loading}
            />
          </View>

          <TouchableOpacity
            style={[styles.loginButton, loading && styles.loginButtonDisabled]}
            onPress={handleLogin}
            disabled={loading}
          >
            {loading ? (
              <ActivityIndicator color="#fff" />
            ) : (
              <Text style={styles.loginButtonText}>تسجيل الدخول</Text>
            )}
          </TouchableOpacity>
        </View>

        <View style={styles.infoContainer}>
          <Text style={styles.infoText}>
            هذا التطبيق يحاكي وظائف تسجيل الدخول إلى Instagram
          </Text>
          <Text style={styles.warningText}>
            ⚠️ استخدم بياناتك الحقيقية بحذر
          </Text>
        </View>
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
    fontSize: 32,
    fontWeight: 'bold',
    color: '#E4405F',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
  formContainer: {
    marginBottom: 30,
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
    textAlign: 'right',
  },
  loginButton: {
    backgroundColor: '#E4405F',
    borderRadius: 8,
    padding: 15,
    alignItems: 'center',
    marginTop: 10,
  },
  loginButtonDisabled: {
    backgroundColor: '#ccc',
  },
  loginButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  infoContainer: {
    alignItems: 'center',
    paddingTop: 20,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  infoText: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
    marginBottom: 10,
  },
  warningText: {
    fontSize: 12,
    color: '#ff6b6b',
    textAlign: 'center',
    fontWeight: '600',
  },
});

export default LoginScreen;

