import { z } from 'zod';

// ── DLStatus (Enum) ──
export const DLStatusSchema = z.enum(['none', 'dlScheduled', 'dlPassed', 'dlPartialyPassed', 'dlFailed', 'dlNotAttended']);
export type DLStatus = z.infer<typeof DLStatusSchema>;