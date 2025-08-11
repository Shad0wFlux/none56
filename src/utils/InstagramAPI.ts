import axios, { AxiosResponse } from 'axios';
import CryptoJS from 'crypto-js';

interface LoginData {
  guid: string;
  enc_password: string;
  username: string;
  device_id: string;
  login_attempt_count: string;
}

interface CheckpointData {
  choice?: string;
  security_code?: string;
  _uuid: string;
  _uid: string;
  _csrftoken: string;
}

export class InstagramAPI {
  private uuid: string;
  private deviceId: string;
  private userAgent: string;
  private cookies: any = {};
  private token: string = '';
  private mid: string = '';
  private sessionid: string = '';

  constructor() {
    this.uuid = '83f2000a-4b95-4811-bc8d-0f3539ef07cf';
    this.deviceId = '';
    this.userAgent = '';
  }

  // Generate random strings
  private randomStringUpper(n: number = 10): string {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return Array.from({ length: n }, () => letters.charAt(Math.floor(Math.random() * letters.length))).join('');
  }

  private randomString(n: number = 10): string {
    const letters = 'abcdefghijklmnopqrstuvwxyz1234567890';
    return Array.from({ length: n }, () => letters.charAt(Math.floor(Math.random() * letters.length))).join('');
  }

  private randomStringChars(n: number = 10): string {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    return Array.from({ length: n }, () => letters.charAt(Math.floor(Math.random() * letters.length))).join('');
  }

  private randomStringWithChar(stringLength: number = 10): string {
    const letters = 'abcdefghijklmnopqrstuvwxyz1234567890';
    const result = Array.from({ length: stringLength - 1 }, () => letters.charAt(Math.floor(Math.random() * letters.length))).join('');
    return this.randomStringChars(1) + result;
  }

  // Generate Device ID
  private generateDeviceId(id: string): string {
    const volatileId = '12345';
    const hash = CryptoJS.MD5(id + volatileId).toString();
    return 'android-' + hash.substring(0, 16);
  }

  // Generate User Agent
  private generateUserAgent(): string {
    const devicesMenu = ['HUAWEI', 'Xiaomi', 'samsung', 'OnePlus'];
    const dpis = ['480', '320', '640', '515', '120', '160', '240', '800'];
    const randResolution = Math.floor(Math.random() * 7 + 2) * 180;
    const lowerResolution = randResolution - 180;

    const deviceSettings = {
      system: 'Android',
      Host: 'Instagram',
      manufacturer: devicesMenu[Math.floor(Math.random() * devicesMenu.length)],
      model: `${devicesMenu[Math.floor(Math.random() * devicesMenu.length)]}-${this.randomStringWithChar(4).toUpperCase()}`,
      android_version: Math.floor(Math.random() * 8 + 18),
      android_release: `${Math.floor(Math.random() * 7 + 1)}.${Math.floor(Math.random() * 8)}`,
      cpu: `${this.randomStringChars(2)}${Math.floor(Math.random() * 9000 + 1000)}`,
      resolution: `${randResolution}x${lowerResolution}`,
      randomL: this.randomString(6),
      dpi: dpis[Math.floor(Math.random() * dpis.length)]
    };

    return `${deviceSettings.Host} 155.0.0.37.107 ${deviceSettings.system} (${deviceSettings.android_version}/${deviceSettings.android_release}; ${deviceSettings.dpi}dpi; ${deviceSettings.resolution}; ${deviceSettings.manufacturer}; ${deviceSettings.model}; ${deviceSettings.cpu}; ${deviceSettings.randomL}; en_US)`;
  }

  // Get login headers
  private getLoginHeaders(): any {
    return {
      'User-Agent': this.userAgent,
      'Host': 'i.instagram.com',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'accept-encoding': 'gzip, deflate',
      'x-fb-http-engine': 'Liger',
      'Connection': 'close'
    };
  }

  // Login function
  async login(username: string, password: string): Promise<any> {
    try {
      this.deviceId = this.generateDeviceId(username);
      this.userAgent = this.generateUserAgent();
      
      const timestamp = Math.floor(Date.now() / 1000).toString();
      
      const loginData: LoginData = {
        guid: this.uuid,
        enc_password: `#PWD_INSTAGRAM:0:${timestamp}:${password}`,
        username: username,
        device_id: this.deviceId,
        login_attempt_count: '0'
      };

      const response: AxiosResponse = await axios.post(
        'https://i.instagram.com/api/v1/accounts/login/',
        new URLSearchParams(loginData as any).toString(),
        {
          headers: this.getLoginHeaders(),
          withCredentials: true
        }
      );

      // Handle cookies
      if (response.headers['set-cookie']) {
        response.headers['set-cookie'].forEach((cookie: string) => {
          const [name, value] = cookie.split('=');
          if (name && value) {
            this.cookies[name] = value.split(';')[0];
          }
        });
        
        this.token = this.cookies.csrftoken || '';
        this.mid = this.cookies.mid || '';
        this.sessionid = this.cookies.sessionid || '';
      }

      if (response.data && typeof response.data === 'string' && response.data.includes('logged_in_user')) {
        return {
          success: true,
          message: `تم تسجيل الدخول بنجاح كـ @${username}`,
          sessionid: this.sessionid,
          data: response.data
        };
      } else if (response.data && typeof response.data === 'string' && response.data.includes('checkpoint_challenge_required')) {
        return {
          success: false,
          requiresCheckpoint: true,
          message: 'مطلوب تحدي الأمان',
          challengePath: this.extractChallengePath(response.data),
          data: response.data
        };
      } else {
        const errorMessage = this.extractErrorMessage(response.data);
        return {
          success: false,
          message: errorMessage || 'حدث خطأ في تسجيل الدخول',
          data: response.data
        };
      }
    } catch (error: any) {
      return {
        success: false,
        message: `خطأ في الشبكة: ${error.message}`,
        error: error
      };
    }
  }

  // Handle checkpoint challenge
  async handleCheckpoint(challengePath: string): Promise<any> {
    try {
      const response = await axios.get(
        `https://i.instagram.com/api/v1${challengePath}`,
        {
          headers: this.getLoginHeaders(),
          withCredentials: true
        }
      );

      const stepData = response.data?.step_data;
      if (stepData) {
        if (stepData.phone_number) {
          return {
            success: true,
            method: 'phone',
            contact: stepData.phone_number,
            message: `رقم الهاتف: ${stepData.phone_number}`
          };
        } else if (stepData.email) {
          return {
            success: true,
            method: 'email',
            contact: stepData.email,
            message: `البريد الإلكتروني: ${stepData.email}`
          };
        }
      }

      return {
        success: false,
        message: 'طريقة تحقق غير معروفة'
      };
    } catch (error: any) {
      return {
        success: false,
        message: `خطأ في تحدي الأمان: ${error.message}`,
        error: error
      };
    }
  }

  // Send choice for checkpoint
  async sendChoice(challengePath: string, choice: string): Promise<any> {
    try {
      const data: CheckpointData = {
        choice: choice,
        _uuid: this.uuid,
        _uid: this.uuid,
        _csrftoken: 'massing'
      };

      const response = await axios.post(
        `https://i.instagram.com/api/v1${challengePath}`,
        new URLSearchParams(data as any).toString(),
        {
          headers: this.getLoginHeaders(),
          withCredentials: true
        }
      );

      const contactPoint = response.data?.step_data?.contact_point;
      if (contactPoint) {
        return {
          success: true,
          message: `تم إرسال الكود إلى: ${contactPoint}`,
          contactPoint: contactPoint
        };
      }

      return {
        success: false,
        message: 'فشل في إرسال الاختيار'
      };
    } catch (error: any) {
      return {
        success: false,
        message: `خطأ في إرسال الاختيار: ${error.message}`,
        error: error
      };
    }
  }

  // Send verification code
  async sendVerificationCode(challengePath: string, code: string): Promise<any> {
    try {
      const data: CheckpointData = {
        security_code: code,
        _uuid: this.uuid,
        _uid: this.uuid,
        _csrftoken: 'massing'
      };

      const response = await axios.post(
        `https://i.instagram.com/api/v1${challengePath}`,
        new URLSearchParams(data as any).toString(),
        {
          headers: this.getLoginHeaders(),
          withCredentials: true
        }
      );

      // Handle cookies
      if (response.headers['set-cookie']) {
        response.headers['set-cookie'].forEach((cookie: string) => {
          const [name, value] = cookie.split('=');
          if (name && value) {
            this.cookies[name] = value.split(';')[0];
          }
        });
        
        this.token = this.cookies.csrftoken || '';
        this.mid = this.cookies.mid || '';
        this.sessionid = this.cookies.sessionid || '';
      }

      if (response.data && typeof response.data === 'string' && response.data.includes('logged_in_user')) {
        return {
          success: true,
          message: 'تم تسجيل الدخول بنجاح',
          sessionid: this.sessionid,
          data: response.data
        };
      } else {
        const errorMessage = this.extractErrorMessage(response.data);
        return {
          success: false,
          message: errorMessage || 'كود التحقق غير صحيح',
          data: response.data
        };
      }
    } catch (error: any) {
      return {
        success: false,
        message: `خطأ في إرسال كود التحقق: ${error.message}`,
        error: error
      };
    }
  }

  // Helper functions
  private extractChallengePath(responseText: string): string {
    try {
      const data = JSON.parse(responseText);
      return data.challenge?.api_path || 
             data.challenge_url?.replace("https://i.instagram.com/api/v1", "") || 
             data.challenge?.url?.replace("https://i.instagram.com/api/v1", "") || 
             data.api_path || 
             data.url || 
             '';
    } catch {
      // Fallback to regex if JSON parsing fails or path is not directly available
      const match = responseText.match(/"api_path":"([^"]+)"/);
      return match ? match[1] : '';
    }
  }

  private extractErrorMessage(responseData: any): string {
    try {
      if (typeof responseData === 'string') {
        const match = responseData.match(/"message":"([^"]+)"/);
        return match ? match[1] : '';
      }
      return responseData?.message || '';
    } catch {
      return '';
    }
  }

  // Get session info
  getSessionInfo(): any {
    return {
      sessionid: this.sessionid,
      token: this.token,
      mid: this.mid,
      deviceId: this.deviceId,
      userAgent: this.userAgent
    };
  }
}

