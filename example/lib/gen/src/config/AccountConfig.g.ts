import { z } from 'zod';

// ── AccountConfig (Type) ──
export interface AccountConfig {
  incomeTypes?: string[] | null;
  expenseTypes?: string[] | null;
  lastUpdatedInvoiceNo?: number | null;
  lastUpdatedCreditNoteNo?: number | null;
  vehicleRelatedCategories: string[];
  franchiseRelatedCategories: string[];
  trainerRelatedCategories: string[];
}

// ── AccountConfig (Schema) ──
export const AccountConfigSchema: z.ZodType<AccountConfig> = z.object({
  incomeTypes: z.array(z.string()).nullish(),
  expenseTypes: z.array(z.string()).nullish(),
  lastUpdatedInvoiceNo: z.number().nullish(),
  lastUpdatedCreditNoteNo: z.number().nullish(),
  vehicleRelatedCategories: z.array(z.string()).default([]),
  franchiseRelatedCategories: z.array(z.string()).default([]),
  trainerRelatedCategories: z.array(z.string()).default([]),
});