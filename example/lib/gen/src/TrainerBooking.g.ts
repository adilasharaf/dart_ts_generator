import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';
import { Address, AddressSchema } from './Address.g';
import { Rider, RiderSchema } from './Rider.g';
import { Vehicle, VehicleSchema } from './Vehicle.g';

// ── TrainerBooking (Type) ──
export interface TrainerBooking {
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
  totalAmountPerKm?: number | null;
  payableAmountPerKm?: number | null;
  minPayableAmount?: number | null;
  maxPayableAmount?: number | null;
  pickupLocation?: Address | null;
  dropLocation?: Address | null;
  pickTime?: Date | null;
  riders?: Rider[] | null;
  vehicle?: Vehicle | null;
}

// ── TrainerBooking (Schema) ──
export const TrainerBookingSchema: z.ZodType<TrainerBooking> = z.object({
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
  totalAmountPerKm: z.number().nullish(),
  payableAmountPerKm: z.number().nullish(),
  minPayableAmount: z.number().nullish(),
  maxPayableAmount: z.number().nullish(),
  pickupLocation: AddressSchema.nullish(),
  dropLocation: AddressSchema.nullish(),
  pickTime: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  riders: z.array(RiderSchema).nullish(),
  vehicle: VehicleSchema.nullish(),
});