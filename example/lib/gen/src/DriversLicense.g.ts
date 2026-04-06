import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';

// ── DriversLicense (Type) ──
export interface DriversLicense {
  id: string;
  name?: string | null;
  fileName?: string | null;
  licenceNumber?: string | null;
  licenceDate?: Date | null;
  licenceExpiry?: Date | null;
  learnersDate?: Date | null;
  learnersExpiry?: Date | null;
  frontUrl?: string | null;
  backUrl?: string | null;
  learnersUrl?: string | null;
  licenceUrl?: string | null;
}

// ── DriversLicense (Schema) ──
export const DriversLicenseSchema: z.ZodType<DriversLicense> = z.object({
  id: z.string(),
  name: z.string().nullish(),
  fileName: z.string().nullish(),
  licenceNumber: z.string().nullish(),
  licenceDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  licenceExpiry: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  learnersDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  learnersExpiry: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  frontUrl: z.string().nullish(),
  backUrl: z.string().nullish(),
  learnersUrl: z.string().nullish(),
  licenceUrl: z.string().nullish(),
});