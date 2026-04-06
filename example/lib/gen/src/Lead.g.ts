import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';
import { Address, AddressSchema } from './Address.g';
import { Rider, RiderSchema } from './Rider.g';
import { CallStatus, CallStatusSchema } from './enums/CallStatus.g';

// ── Lead (Type) ──
export interface Lead {
  id: string;
  addedOn?: Date | null;
  addedBy?: EiUser | null;
  modifiedOn?: Date | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  userId?: string | null;
  email?: string | null;
  phone?: string | null;
  photoUrl?: string | null;
  displayName?: string | null;
  address?: Address | null;
  currentLocation?: Address | null;
  gender?: string | null;
  bloodGroup?: string | null;
  pendingAmount: number;
  deviceTokens: string[];
  isDeleted?: boolean | null;
  deletedOn?: Date | null;
  leadId?: string | null;
  rider?: Rider | null;
  followUpDate?: Date | null;
  callStatus: CallStatus;
  leadSource: string;
  dueDate?: Date | null;
}

// ── Lead (Schema) ──
export const LeadSchema: z.ZodType<Lead> = z.object({
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
  userId: z.string().nullish(),
  email: z.string().nullish(),
  phone: z.string().nullish(),
  photoUrl: z.string().nullish(),
  displayName: z.string().nullish(),
  address: AddressSchema.nullish(),
  currentLocation: AddressSchema.nullish(),
  gender: z.string().nullish(),
  bloodGroup: z.string().nullish(),
  pendingAmount: z.number().default(0.0),
  deviceTokens: z.array(z.string()).default([]),
  isDeleted: z.boolean().nullish().default(false),
  deletedOn: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  leadId: z.string().nullish(),
  rider: RiderSchema.nullish(),
  followUpDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  callStatus: CallStatusSchema.default("pending"),
  leadSource: z.string().default("Unknown"),
  dueDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
});