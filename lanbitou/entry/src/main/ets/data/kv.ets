import dataPreferences from '@ohos.data.preferences'

const STORE_NAME = 'lanbitou_store'
const NOTE_PREFIX = 'note:'

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
