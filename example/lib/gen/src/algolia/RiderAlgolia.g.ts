import { z } from 'zod';

// ── RiderAlgolia (Type) ──
export interface RiderAlgolia {
  id?: string | null;
  displayName?: string | null;
  phone?: string | null;
  photoUrl?: string | null;
  'driversLicense.licenceVerificationStatus'?: string | null;
}

// ── RiderAlgolia (Schema) ──
export const RiderAlgoliaSchema: z.ZodType<RiderAlgolia> = z.object({
  id: z.string().nullish(),
  displayName: z.string().nullish(),
  phone: z.string().nullish(),
  photoUrl: z.string().nullish(),
  'driversLicense.licenceVerificationStatus': z.string().nullish().default("unknown"),
});