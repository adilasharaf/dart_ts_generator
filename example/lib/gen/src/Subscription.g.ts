import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';

// ── Subscription (Type) ──
export interface Subscription {
  id: string;
  addedOn?: Date | null;
  addedBy?: EiUser | null;
  modifiedOn?: Date | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  name: string;
  description: string;
  effectivePriceLmv?: number | null;
  effectivePriceMc?: number | null;
  lmvBookingLimit: number;
  mcBookingLimit: number;
  rtoTestBookingLimit: number;
  mockTestBookingLimit: number;
  lmvBookingTotal: number;
  mcBookingTotal: number;
  rtoTestBookingTotal: number;
  mockTestBookingTotal: number;
  startDate?: Date | null;
  endDate?: Date | null;
  amount: number;
  gst: number;
}

// ── Subscription (Schema) ──
export const SubscriptionSchema: z.ZodType<Subscription> = z.object({
  id: z.string(),
  addedOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  addedBy: EiUserSchema.nullish(),
  modifiedOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  modifiedBy: z.string().nullish(),
  operationId: z.string().nullish(),
  name: z.string().default(""),
  description: z.string().default(""),
  effectivePriceLmv: z.number().nullish(),
  effectivePriceMc: z.number().nullish(),
  lmvBookingLimit: z.number().int().default(0),
  mcBookingLimit: z.number().int().default(0),
  rtoTestBookingLimit: z.number().int().default(0),
  mockTestBookingLimit: z.number().int().default(0),
  lmvBookingTotal: z.number().int().default(0),
  mcBookingTotal: z.number().int().default(0),
  rtoTestBookingTotal: z.number().int().default(0),
  mockTestBookingTotal: z.number().int().default(0),
  startDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  endDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  amount: z.number().default(0),
  gst: z.number().default(0),
});