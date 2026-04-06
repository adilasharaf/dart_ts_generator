import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';

// ── Vehicle (Type) ──
export interface Vehicle {
  id: string;
  addedOn?: Date | null;
  addedBy?: EiUser | null;
  modifiedOn?: Date | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  make: string;
  model: string;
  year?: number | null;
  imageUrl: string;
  savedAs?: string | null;
  kmsDriven?: number | null;
  vehicleNumber?: string | null;
  variant?: string | null;
  makeCountry?: string | null;
  priceFactor: number;
  assignedTrainerId?: string | null;
  capacity?: number | null;
  isPickupAvailable: boolean;
}

// ── Vehicle (Schema) ──
export const VehicleSchema: z.ZodType<Vehicle> = z.object({
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
  make: z.string(),
  model: z.string(),
  year: z.number().int().nullish(),
  imageUrl: z.string(),
  savedAs: z.string().nullish(),
  kmsDriven: z.number().int().nullish(),
  vehicleNumber: z.string().nullish(),
  variant: z.string().nullish(),
  makeCountry: z.string().nullish(),
  priceFactor: z.number().default(1.0),
  assignedTrainerId: z.string().nullish(),
  capacity: z.number().int().nullish(),
  isPickupAvailable: z.boolean().default(true),
});