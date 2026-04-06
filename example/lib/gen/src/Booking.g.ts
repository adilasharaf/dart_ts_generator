import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';

// ── Booking (Type) ──
export interface Booking {
  id: string;
  bookedBy: EiUser;
  totalAmount?: number | null;
  payableAmount?: number | null;
  effectivePrice?: number | null;
  cancellationNote?: string | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  pendingAmountCollected: number;
  cancellationCharge: number;
  cancelledOn?: Date | null;
  bookedOn?: Date | null;
  modifiedOn?: Date | null;
}

// ── Booking (Schema) ──
export const BookingSchema: z.ZodType<Booking> = z.object({
  id: z.string(),
  bookedBy: EiUserSchema,
  totalAmount: z.number().nullish(),
  payableAmount: z.number().nullish(),
  effectivePrice: z.number().nullish(),
  cancellationNote: z.string().nullish(),
  modifiedBy: z.string().nullish(),
  operationId: z.string().nullish(),
  pendingAmountCollected: z.number().default(0.0),
  cancellationCharge: z.number().default(0.0),
  cancelledOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  bookedOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  modifiedOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
});