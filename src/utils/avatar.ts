import { resolveMediaUrl } from '../services/api'

export const DEFAULT_AVATAR = '/static/images/profile/default-avatar.svg'

/** 用户头像 URL，无头像时使用默认图 */
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
