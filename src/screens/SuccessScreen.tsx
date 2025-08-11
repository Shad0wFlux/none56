import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Clipboard,
  Alert,
} from 'react-native';

interface SuccessScreenProps {
  sessionInfo: any;
  onLogout: () => void;
}

const SuccessScreen: React.FC<SuccessScreenProps> = ({ sessionInfo, onLogout }) => {
  const copyToClipboard = (text: string, label: string) => {
    Clipboard.setString(text);
    Alert.alert('تم النسخ', `تم نسخ ${label} إلى الحافظة`);
  };

  const formatSessionInfo = () => {
    return [
      { label: 'Session ID', value: sessionInfo.sessionid || 'غير متوفر' },
      { label: 'Token', value: sessionInfo.token || 'غير متوفر' },
      { label: 'MID', value: sessionInfo.mid || 'غير متوفر' },
      { label: 'Device ID', value: sessionInfo.deviceId || 'غير متوفر' },
      { label: 'User Agent', value: sessionInfo.userAgent || 'غير متوفر' },
    ];
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.headerContainer}>
        <Text style={styles.successIcon}>✅</Text>
        <Text style={styles.title}>تم تسجيل الدخول بنجاح!</Text>
        <Text style={styles.subtitle}>Instagram Login Successful</Text>
      </View>

      <View style={styles.infoContainer}>
        <Text style={styles.sectionTitle}>معلومات الجلسة</Text>
        
        {formatSessionInfo().map((item, index) => (
          <View key={index} style={styles.infoItem}>
            <View style={styles.infoHeader}>
              <Text style={styles.infoLabel}>{item.label}</Text>
              <TouchableOpacity
                style={styles.copyButton}
                onPress={() => copyToClipboard(item.value, item.label)}
              >
                <Text style={styles.copyButtonText}>نسخ</Text>
              </TouchableOpacity>
            </View>
            <Text style={styles.infoValue} numberOfLines={2}>
              {item.value}
            </Text>
          </View>
        ))}
      </View>

      <View style={styles.actionsContainer}>
        <TouchableOpacity
          style={styles.copyAllButton}
          onPress={() => {
            const allInfo = formatSessionInfo()
              .map(item => `${item.label}: ${item.value}`)
              .join('\n\n');
            copyToClipboard(allInfo, 'جميع المعلومات');
          }}
        >
          <Text style={styles.copyAllButtonText}>نسخ جميع المعلومات</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.logoutButton} onPress={onLogout}>
          <Text style={styles.logoutButtonText}>تسجيل خروج</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.warningContainer}>
        <Text style={styles.warningTitle}>⚠️ تنبيه مهم</Text>
        <Text style={styles.warningText}>
          • احتفظ بمعلومات الجلسة في مكان آمن{'\n'}
          • لا تشارك هذه المعلومات مع أي شخص{'\n'}
          • استخدم هذه المعلومات بمسؤولية{'\n'}
          • قم بتسجيل الخروج عند الانتهاء
        </Text>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  headerContainer: {
    alignItems: 'center',
    padding: 30,
    backgroundColor: '#f8f9fa',
  },
  successIcon: {
    fontSize: 60,
    marginBottom: 15,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#28a745',
    marginBottom: 8,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
  infoContainer: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 20,
    textAlign: 'right',
  },
  infoItem: {
    backgroundColor: '#f8f9fa',
    padding: 15,
    borderRadius: 8,
    marginBottom: 15,
    borderLeftWidth: 4,
    borderLeftColor: '#E4405F',
  },
  infoHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  infoLabel: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
  },
  copyButton: {
    backgroundColor: '#E4405F',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 4,
  },
  copyButtonText: {
    color: '#fff',
    fontSize: 12,
    fontWeight: '600',
  },
  infoValue: {
    fontSize: 14,
    color: '#666',
    fontFamily: 'monospace',
    lineHeight: 20,
  },
  actionsContainer: {
    padding: 20,
    paddingTop: 0,
  },
  copyAllButton: {
    backgroundColor: '#17a2b8',
    borderRadius: 8,
    padding: 15,
    alignItems: 'center',
    marginBottom: 15,
  },
  copyAllButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  logoutButton: {
    backgroundColor: '#dc3545',
    borderRadius: 8,
    padding: 15,
    alignItems: 'center',
  },
  logoutButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  warningContainer: {
    margin: 20,
    padding: 15,
    backgroundColor: '#fff3cd',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ffeaa7',
  },
  warningTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#856404',
    marginBottom: 10,
    textAlign: 'right',
  },
  warningText: {
    fontSize: 14,
    color: '#856404',
    lineHeight: 22,
    textAlign: 'right',
  },
});

export default SuccessScreen;

