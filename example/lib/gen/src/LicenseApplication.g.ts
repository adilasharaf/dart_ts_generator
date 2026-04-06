import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';
import { Rto, RtoSchema } from './Rto.g';
import { Rider, RiderSchema } from './Rider.g';
import { DLStatus, DLStatusSchema } from './enums/DLStatus.g';

// ── LicenseApplication (Type) ──
export interface LicenseApplication {
  id: string;
  addedOn?: Date | null;
  addedBy?: EiUser | null;
  modifiedOn?: Date | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  fullName?: string | null;
  applicationNumber?: string | null;
  gender?: string | null;
  bloodGroup?: string | null;
  phone?: string | null;
  nationality?: string | null;
  selectedRto?: Rto | null;
  rider?: Rider | null;
  dlStatus: DLStatus;
  isAlreadyHaveLicence: boolean;
  llExpiry?: Date | null;
  dob?: Date | null;
  rtoPaymentCompletedDate?: Date | null;
  formFilledDate?: Date | null;
  eyeTestUploadPendingDate?: Date | null;
  eyeTestUploadCompletedDate?: Date | null;
  docsRequestedDate?: Date | null;
  docsUploadedDate?: Date | null;
  applicationStartedDate?: Date | null;
  rtoVerifiedDate?: Date | null;
  rsaDate?: Date | null;
  rsaCompletedDate?: Date | null;
  llTestSchedule?: Date | null;
  dlTestSchedule?: Date | null;
  completedDate?: Date | null;
}

// ── LicenseApplication (Schema) ──
export const LicenseApplicationSchema: z.ZodType<LicenseApplication> = z.object({
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
  fullName: z.string().nullish(),
  applicationNumber: z.string().nullish(),
  gender: z.string().nullish(),
  bloodGroup: z.string().nullish(),
  phone: z.string().nullish(),
  nationality: z.string().nullish(),
  selectedRto: RtoSchema.nullish(),
  rider: RiderSchema.nullish(),
  dlStatus: DLStatusSchema.default("none"),
  isAlreadyHaveLicence: z.boolean().default(false),
  llExpiry: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  dob: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  rtoPaymentCompletedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  formFilledDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  eyeTestUploadPendingDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  eyeTestUploadCompletedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  docsRequestedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  docsUploadedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  applicationStartedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  rtoVerifiedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  rsaDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  rsaCompletedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  llTestSchedule: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  dlTestSchedule: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
  completedDate: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
});