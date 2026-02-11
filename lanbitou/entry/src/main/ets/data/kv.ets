import dataPreferences from '@ohos.data.preferences'

const STORE_NAME = 'lanbitou_store'
const NOTE_PREFIX = 'note:'
const CATEGORY_PREFIX = 'cat:'
const TAG_PREFIX = 'tag:'

let prefs: dataPreferences.Preferences | null = null

export async function getPrefs(context: any): Promise<dataPreferences.Preferences> {
  if (prefs) return prefs
  prefs = await dataPreferences.getPreferences(context, STORE_NAME)
  return prefs
}

export async function saveNote(context: any, note: any): Promise<void> {
  const p = await getPrefs(context)
  await p.put(NOTE_PREFIX + note.id, JSON.stringify(note))
  await p.flush()
}

export async function listNotes(context: any): Promise<any[]> {
  const p = await getPrefs(context)
  const all = await p.getAll()
  const notes: any[] = []
  Object.keys(all).forEach(key => {
    if (key.startsWith(NOTE_PREFIX)) {
      try {
        const raw = all[key] as string
        notes.push(JSON.parse(raw))
      } catch (e) {
      }
    }
  })
  notes.sort((a, b) => b.updatedAt - a.updatedAt)
  return notes
}

export async function saveCategory(context: any, category: any): Promise<void> {
  const p = await getPrefs(context)
  await p.put(CATEGORY_PREFIX + category.id, JSON.stringify(category))
  await p.flush()
}

export async function listCategories(context: any): Promise<any[]> {
  const p = await getPrefs(context)
  const all = await p.getAll()
  const items: any[] = []
  Object.keys(all).forEach(key => {
    if (key.startsWith(CATEGORY_PREFIX)) {
      try {
        items.push(JSON.parse(all[key] as string))
      } catch (e) {}
    }
  })
  return items
}

export async function saveTag(context: any, tag: any): Promise<void> {
  const p = await getPrefs(context)
  await p.put(TAG_PREFIX + tag.id, JSON.stringify(tag))
  await p.flush()
}

export async function listTags(context: any): Promise<any[]> {
  const p = await getPrefs(context)
  const all = await p.getAll()
  const items: any[] = []
  Object.keys(all).forEach(key => {
    if (key.startsWith(TAG_PREFIX)) {
      try {
        items.push(JSON.parse(all[key] as string))
      } catch (e) {}
    }
  })
  return items
}

export async function findOrCreateCategory(context: any, name: string): Promise<any | null> {
  if (!name) return null
  const list = await listCategories(context)
  const found = list.find(c => c.name === name)
  if (found) return found
  const now = Date.now()
  const cat = { id: now.toString(), name }
  await saveCategory(context, cat)
  return cat
}

export async function findOrCreateTags(context: any, names: string[]): Promise<string[]> {
  const ids: string[] = []
  for (const name of names) {
    const trimmed = name.trim()
    if (!trimmed) continue
    const list = await listTags(context)
    const found = list.find(t => t.name === trimmed)
    if (found) {
      ids.push(found.id)
    } else {
      const now = Date.now() + Math.floor(Math.random() * 1000)
      const tag = { id: now.toString(), name: trimmed }
      await saveTag(context, tag)
      ids.push(tag.id)
    }
  }
  return ids
}
