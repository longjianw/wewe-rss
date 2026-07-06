export const isProd = import.meta.env.PROD;

export const serverOriginUrl = isProd
  ? window.__WEWE_RSS_SERVER_ORIGIN_URL__
  : import.meta.env.VITE_SERVER_ORIGIN_URL;

export const appVersion = __APP_VERSION__;

const enabledAuthCodeValue = window.__WEWE_RSS_ENABLED_AUTH_CODE__ as
  | boolean
  | string
  | undefined;

export const enabledAuthCode =
  enabledAuthCodeValue === true || enabledAuthCodeValue === 'true';
