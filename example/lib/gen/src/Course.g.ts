import { z } from 'zod';
import { Timestamp } from 'firebase-admin/firestore';
import { EiUser, EiUserSchema } from './EiUser.g';
import { CourseStatus, CourseStatusSchema } from './enums/CourseStatus.g';
import { Subscription, SubscriptionSchema } from './Subscription.g';

// ── Course (Type) ──
export interface Course {
  id: string;
  addedOn?: Date | null;
  addedBy?: EiUser | null;
  modifiedOn?: Date | null;
  modifiedBy?: string | null;
  operationId?: string | null;
  name?: string | null;
  description?: string | null;
  status: CourseStatus;
  serviceCharge: number;
  rtoFee: number;
  gst: number;
  subscriptions: Subscription[];
  dueDate?: Date | null;
}

// ── Course (Schema) ──
export const CourseSchema: z.ZodType<Course> = z.object({
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
  name: z.string().nullish(),
  description: z.string().nullish(),
  status: CourseStatusSchema.default("none"),
  serviceCharge: z.number().default(0),
  rtoFee: z.number().default(0),
  gst: z.number().default(0),
  subscriptions: z.array(SubscriptionSchema).default([]),
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