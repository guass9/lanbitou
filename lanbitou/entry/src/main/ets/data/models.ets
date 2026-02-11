export interface Note {
  id: string
  title: string
  contentMd: string
  createdAt: number
  updatedAt: number
  categoryId?: string
  tagIds?: string[]
  reminderId?: string
}

export interface Category {
  id: string
  name: string
  parentId?: string
  color?: string
}

export interface Tag {
  id: string
  name: string
  color?: string
}

export interface Reminder {
  id: string
  noteId: string
  time: number
  repeatRule?: string
  priority?: number
  enabled: boolean
}
