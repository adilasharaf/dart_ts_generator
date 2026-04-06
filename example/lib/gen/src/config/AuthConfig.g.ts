import { z } from 'zod';

// ── AuthConfig (Type) ──
export interface AuthConfig {
  admin: string[];
  franchise: string[];
}

// ── AuthConfig (Schema) ──
export const AuthConfigSchema: z.ZodType<AuthConfig> = z.object({
  admin: z.array(z.string()).default([]),
  franchise: z.array(z.string()).default([]),
});