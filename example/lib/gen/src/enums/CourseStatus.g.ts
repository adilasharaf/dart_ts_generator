import { z } from 'zod';

// ── CourseStatus (Enum) ──
export const CourseStatusSchema = z.enum(['none', 'enrolled', 'completed', 'cancelled']);
export type CourseStatus = z.infer<typeof CourseStatusSchema>;