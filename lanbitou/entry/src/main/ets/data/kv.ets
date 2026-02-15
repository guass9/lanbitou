import dataPreferences from '@ohos.data.preferences'
import common from '@ohos.app.ability.common'

const STORE_NAME: string = 'lanbitou_store'
const NOTE_PREFIX: string = 'note:'
const CATEGORY_PREFIX: string = 'cat:'
const TAG_PREFIX: string = 'tag:'

export interface NoteItem {
  id: string
  title: string
  contentMd: string
  updatedAt: number
  categoryId?: string
  tagIds?: string[]
}

export interface CategoryItem {
  id: string
  name: string
}

export interface TagItem {
  id: string
  name: string
}

let prefs: dataPreferences.Preferences | null = null

function toStringSafe(v: Object): string {
  if (typeof v === 'string') {
    return v
  }
  return ''
}

function parseNote(raw: string): NoteItem | null {
  try {
    return JSON.parse(raw) as NoteItem
  } catch (_) {
    return null
  }
}

function parseCategory(raw: string): CategoryItem | null {
  try {
    return JSON.parse(raw) as CategoryItem
  } catch (_) {
    return null
  }
}

function parseTag(raw: string): TagItem | null {
  try {
    return JSON.parse(raw) as TagItem
  } catch (_) {
    return null
  }
}

export async function getPrefs(context: common.Context): Promise<dataPreferences.Preferences> {
  if (prefs !== null) {
    return prefs
  }
  const p: dataPreferences.Preferences = await dataPreferences.getPreferences(context, STORE_NAME)
  prefs = p
  return p
}

export async function saveNote(context: common.Context, note: NoteItem): Promise<void> {
  const p = await getPrefs(context)
  await p.put(NOTE_PREFIX + note.id, JSON.stringify(note))
  await p.flush()
}

export async function listNotes(context: common.Context): Promise<NoteItem[]> {
  const p = await getPrefs(context)
  const allObj: Object = await p.getAll()
  const all: Map<string, Object> = allObj as Map<string, Object>
  const notes: NoteItem[] = []

  const keys: string[] = Array.from(all.keys())
  for (const key of keys) {
    if (!key.startsWith(NOTE_PREFIX)) continue
    const raw: string = toStringSafe(all.get(key) as Object)
    if (raw.length === 0) continue
    const n = parseNote(raw)
    if (n !== null) notes.push(n)
  }

  notes.sort((a: NoteItem, b: NoteItem) => b.updatedAt - a.updatedAt)
  return notes
}

export async function saveCategory(context: common.Context, category: CategoryItem): Promise<void> {
  const p = await getPrefs(context)
  await p.put(CATEGORY_PREFIX + category.id, JSON.stringify(category))
  await p.flush()
}

export async function listCategories(context: common.Context): Promise<CategoryItem[]> {
  const p = await getPrefs(context)
  const allObj: Object = await p.getAll()
  const all: Map<string, Object> = allObj as Map<string, Object>
  const items: CategoryItem[] = []

  const keys: string[] = Array.from(all.keys())
  for (const key of keys) {
    if (!key.startsWith(CATEGORY_PREFIX)) continue
    const raw: string = toStringSafe(all.get(key) as Object)
    if (raw.length === 0) continue
    const c = parseCategory(raw)
    if (c !== null) items.push(c)
  }
  return items
}

export async function saveTag(context: common.Context, tag: TagItem): Promise<void> {
  const p = await getPrefs(context)
  await p.put(TAG_PREFIX + tag.id, JSON.stringify(tag))
  await p.flush()
}

export async function listTags(context: common.Context): Promise<TagItem[]> {
  const p = await getPrefs(context)
  const allObj: Object = await p.getAll()
  const all: Map<string, Object> = allObj as Map<string, Object>
  const items: TagItem[] = []

  const keys: string[] = Array.from(all.keys())
  for (const key of keys) {
    if (!key.startsWith(TAG_PREFIX)) continue
    const raw: string = toStringSafe(all.get(key) as Object)
    if (raw.length === 0) continue
    const t = parseTag(raw)
    if (t !== null) items.push(t)
  }
  return items
}

export async function findOrCreateCategory(context: common.Context, name: string): Promise<CategoryItem | null> {
  const trimmed = name.trim()
  if (trimmed.length === 0) return null

  const list = await listCategories(context)
  const found = list.find((c: CategoryItem) => c.name === trimmed)
  if (found !== undefined) return found

  const cat: CategoryItem = { id: Date.now().toString(), name: trimmed }
  await saveCategory(context, cat)
  return cat
}

export async function findOrCreateTags(context: common.Context, names: string[]): Promise<string[]> {
  const ids: string[] = []
  for (const name of names) {
    const trimmed = name.trim()
    if (trimmed.length === 0) continue

    const list = await listTags(context)
    const found = list.find((t: TagItem) => t.name === trimmed)
    if (found !== undefined) {
      ids.push(found.id)
    } else {
      const tag: TagItem = {
        id: (Date.now() + Math.floor(Math.random() * 1000)).toString(),
        name: trimmed
      }
      await saveTag(context, tag)
      ids.push(tag.id)
    }
  }
  return ids
}