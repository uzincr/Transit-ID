const getApiBaseUrl = () => {
  const host = window.location.hostname;
  if (host === 'localhost' || host === '127.0.0.1') {
    // Docker maps backend to port 8004 on the host machine.
    return 'http://localhost:8004/api';
  }
  // Cloud Domain
  if (host.includes('transit-id.uzinc.uz')) {
    return 'https://api-transitid.uzinc.uz/api';
  }
  // Fallback to local port 8004
  return `http://${host}:8004/api`;
};

const BASE_URL = getApiBaseUrl();

const getHeaders = () => {
  const headers = {
    'Content-Type': 'application/json',
  };
  const token = localStorage.getItem('transitid_token');
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  return headers;
};

export const api = {
  getToken: () => localStorage.getItem('transitid_token'),
  logout: () => localStorage.removeItem('transitid_token'),

  sendOtp: async (phone) => {
    const res = await fetch(`${BASE_URL}/auth/otp/send`, {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify({ phone }),
    });
    if (!res.ok) throw new Error('OTP send failed');
    return res.json();
  },

  verifyOtp: async (phone, otp) => {
    const res = await fetch(`${BASE_URL}/auth/otp/verify`, {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify({ phone, otp }),
    });
    if (!res.ok) throw new Error('Verification failed');
    const data = await res.json();
    if (data.accessToken) {
      localStorage.setItem('transitid_token', data.accessToken);
    }
    return data;
  },

  getDrivers: async () => {
    const res = await fetch(`${BASE_URL}/users`, {
      headers: getHeaders(),
    });
    if (!res.ok) throw new Error('Failed to fetch drivers');
    return res.json();
  },

  getLicenses: async () => {
    const res = await fetch(`${BASE_URL}/licenses`, {
      headers: getHeaders(),
    });
    if (!res.ok) throw new Error('Failed to fetch licenses');
    return res.json();
  },

  createLicense: async (data) => {
    const res = await fetch(`${BASE_URL}/licenses`, {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create license');
    return res.json();
  },

  updateLicense: async (id, data) => {
    const res = await fetch(`${BASE_URL}/licenses/${id}`, {
      method: 'PATCH',
      headers: getHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update license');
    return res.json();
  },

  getPayments: async () => {
    const res = await fetch(`${BASE_URL}/payments`, {
      headers: getHeaders(),
    });
    if (!res.ok) throw new Error('Failed to fetch payments');
    return res.json();
  },
};
