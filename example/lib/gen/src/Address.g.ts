import { z } from 'zod';
import { GeoPoint } from 'firebase-admin/firestore';

// ── Address (Type) ──
export interface Address {
  id: string;
  line1?: string | null;
  line2?: string | null;
  city?: string | null;
  district?: string | null;
  state?: string | null;
  pin?: string | null;
  latitude?: number | null;
  longitude?: number | null;
  savedAs?: string | null;
  fullAddress?: string | null;
  geoHash?: string | null;
  geoPoint?: GeoPoint | null;
}

// ── Address (Schema) ──
export const AddressSchema: z.ZodType<Address> = z.object({
  id: z.string(),
  line1: z.string().nullish(),
  line2: z.string().nullish(),
  city: z.string().nullish(),
  district: z.string().nullish(),
  state: z.string().nullish(),
  pin: z.string().nullish(),
  latitude: z.number().nullish(),
  longitude: z.number().nullish(),
  savedAs: z.string().nullish(),
  fullAddress: z.string().nullish(),
  geoHash: z.string().nullish(),
  geoPoint: z.instanceof(GeoPoint).nullish(),
});