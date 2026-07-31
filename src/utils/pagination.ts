/** 鏍规嵁鎬绘潯鏁颁笌姣忛〉鏉℃暟璁＄畻鎬婚〉鏁帮紙size 鏄瘡椤垫潯鏁帮紝涓嶆槸鎬婚〉鏁帮級 */
export function calcTotalPages(totalItems: number, pageSize: number): number {
  if (totalItems <= 0 || pageSize <= 0) {
    return 0
  }
  return Math.ceil(totalItems / pageSize)
}

export function normalizeWordCardPage<T>(
  data: {
    content?: T[]
    currentPage?: number
    totalItems?: number
    totalPages?: number
    pageSize?: number
  },
  page: number,
  pageSize: number
) {
  const totalItems = data.totalItems ?? 0
  return {
    content: data.content ?? [],
    currentPage: data.currentPage ?? page,
    pageSize: data.pageSize ?? pageSize,
    totalItems,
    totalPages: calcTotalPages(totalItems, pageSize)
  }
}
