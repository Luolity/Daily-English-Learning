import { resolveMediaUrl } from '../services/api'

export const DEFAULT_AVATAR = '/static/images/profile/default-avatar.svg'

/** 鐢ㄦ埛澶村儚 URL锛屾棤澶村儚鏃朵娇鐢ㄩ粯璁ゅ浘 */
export function getUserAvatarUrl(avatar?: string | null): string {
  if (!avatar || !String(avatar).trim()) {
    return DEFAULT_AVATAR
  }
  const url = resolveMediaUrl(avatar)
  if (!url || url.includes('default-avatar')) {
    return DEFAULT_AVATAR
  }
  return url
}
