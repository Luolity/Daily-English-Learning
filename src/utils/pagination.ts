/** 根据总条数与每页条数计算总页数（size 是每页条数，不是总页数） */
export function calcTotalPages(totalItems: number, pageSize: number): number {
  if (totalItems <= 0 || pageSize <= 0) {
    return 0
  }
  return Math.ceil(totalItems / pageSize)
}

export function normalizeWordCardPage(
  data: {
    content?: unknown[]
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
