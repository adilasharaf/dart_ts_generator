import { z } from 'zod';
import { Address, AddressSchema } from './Address.g';

// ── Rto (Type) ──
export interface Rto {
  id: string;
  name?: string | null;
  address?: Address | null;
}

// ── Rto (Schema) ──
export const RtoSchema: z.ZodType<Rto> = z.object({
  id: z.string(),
  name: z.string().nullish(),
  address: AddressSchema.nullish(),
});