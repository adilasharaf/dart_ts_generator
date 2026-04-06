import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';
import { Address, AddressSchema } from './Address.g';
import { Vehicle, VehicleSchema } from './Vehicle.g';
import { DriversLicense, DriversLicenseSchema } from './DriversLicense.g';
import { LicenseApplication, LicenseApplicationSchema } from './LicenseApplication.g';
import { Course, CourseSchema } from './Course.g';
import { Rto, RtoSchema } from './Rto.g';

// ── Rider (Type) ──
export interface Rider {
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
  vehicles?: Vehicle[] | null;
  savedAddresses?: Address[] | null;
  kmsDriven: number;
  driversLicense?: DriversLicense | null;
  licenseApplication?: LicenseApplication | null;
  lastBookedAddress?: Address | null;
  trainInRiderVehicleEnabled: boolean;
  riderCategories: string[];
  appVersion?: string | null;
  appBuildNumber?: number | null;
  course?: Course | null;
  selectedRto?: Rto | null;
  dob?: Date | null;
}

// ── Rider (Schema) ──
export const RiderSchema: z.ZodType<Rider> = z.object({
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
  vehicles: z.array(VehicleSchema).nullish(),
  savedAddresses: z.array(AddressSchema).nullish(),
  kmsDriven: z.number().default(0.0),
  driversLicense: DriversLicenseSchema.nullish(),
  licenseApplication: LicenseApplicationSchema.nullish(),
  lastBookedAddress: AddressSchema.nullish(),
  trainInRiderVehicleEnabled: z.boolean().default(false),
  riderCategories: z.array(z.string()).default([]),
  appVersion: z.string().nullish(),
  appBuildNumber: z.number().int().nullish(),
  course: CourseSchema.nullish(),
  selectedRto: RtoSchema.nullish(),
  dob: z.union([
  z.date(),
  z.number(),
  z.instanceof(Timestamp)
]).transform((val) => {
  if (val instanceof Date) return val;
  if (typeof val === 'number') return new Date(val);
  return val.toDate();
}).nullish(),
});