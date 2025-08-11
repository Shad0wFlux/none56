import React, { useState } from 'react';
import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
} from 'react-native';
import LoginScreen from './src/screens/LoginScreen';
import CheckpointScreen from './src/screens/CheckpointScreen';
import SuccessScreen from './src/screens/SuccessScreen';
import { InstagramAPI } from './src/utils/InstagramAPI';

type AppState = 'login' | 'checkpoint' | 'success';

interface CheckpointData {
  challengePath: string;
  api: InstagramAPI;
}

const App: React.FC = () => {
  const [currentScreen, setCurrentScreen] = useState<AppState>('login');
  const [sessionInfo, setSessionInfo] = useState<any>(null);
  const [checkpointData, setCheckpointData] = useState<CheckpointData | null>(null);

  const handleLoginSuccess = (sessionData: any) => {
    setSessionInfo(sessionData);
    setCurrentScreen('success');
  };

  const handleCheckpointRequired = (challengePath: string, api: InstagramAPI) => {
    setCheckpointData({ challengePath, api });
    setCurrentScreen('checkpoint');
  };

  const handleLogout = () => {
    setSessionInfo(null);
    setCheckpointData(null);
    setCurrentScreen('login');
  };

  const handleBackToLogin = () => {
    setCheckpointData(null);
    setCurrentScreen('login');
  };

  const renderCurrentScreen = () => {
    switch (currentScreen) {
      case 'login':
        return (
          <LoginScreen
            onLoginSuccess={handleLoginSuccess}
            onCheckpointRequired={handleCheckpointRequired}
          />
        );
      case 'checkpoint':
        return checkpointData ? (
          <CheckpointScreen
            challengePath={checkpointData.challengePath}
            api={checkpointData.api}
            onLoginSuccess={handleLoginSuccess}
            onBack={handleBackToLogin}
          />
        ) : null;
      case 'success':
        return (
          <SuccessScreen
            sessionInfo={sessionInfo}
            onLogout={handleLogout}
          />
        );
      default:
        return (
          <LoginScreen
            onLoginSuccess={handleLoginSuccess}
            onCheckpointRequired={handleCheckpointRequired}
          />
        );
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#fff" />
      {renderCurrentScreen()}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
});

export default App;
