import { z } from 'zod';

// ── CallStatus (Enum) ──
export const CallStatusSchema = z.enum(['pending', 'didntConnect', 'didntPickup', 'interested', 'notInterested']);
export type CallStatus = z.infer<typeof CallStatusSchema>;