class X2DLCInfo_ChosenBrutalFix extends X2DownloadableContentInfo config(GameData_SoldierSkills);

var config(Engine) bool EnableDebug;

var config array<name> BRUTAL_EFFECT_FIX;

static event OnPostTemplatesCreated()
{
	ReplaceBrutalEffectFromAbilities();
	ReplaceBrutalEffectFromItems();
}

static function ReplaceBrutalEffectFromAbilities()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_BrutalFix BrutalEffectFix;
	local X2Effect_Brutal OriginalBrutalEffect;
	local name TemplateName;
	local int Index;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.BRUTAL_EFFECT_FIX(TemplateName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(TemplateName);

		if (AbilityTemplate == none)
		{
			continue;
		}

		for (Index = AbilityTemplate.AbilityTargetEffects.Length - 1; Index >= 0; Index--)
		{
			OriginalBrutalEffect = X2Effect_Brutal(AbilityTemplate.AbilityTargetEffects[Index]);

			if (OriginalBrutalEffect == none)
			{
				continue;
			}

			`Log("Fixing target effect for ability" @ TemplateName, default.EnableDebug, 'ChosenBrutalFix');
			`Log("Original effect Will modifier:" @ OriginalBrutalEffect.WillMod, default.EnableDebug, 'ChosenBrutalFix');

			BrutalEffectFix = new class'X2Effect_BrutalFix';
			BrutalEffectFix.WillMod = OriginalBrutalEffect.WillMod;

			AbilityTemplate.AbilityTargetEffects.Remove(Index, 1);
			AbilityTemplate.AddTargetEffect(BrutalEffectFix);

			`Log("New effect Will modifier:" @ BrutalEffectFix.WillMod, default.EnableDebug, 'ChosenBrutalFix');

			break;
		}

		for (Index = AbilityTemplate.AbilityMultiTargetEffects.Length - 1; Index >= 0; Index--)
		{
			OriginalBrutalEffect = X2Effect_Brutal(AbilityTemplate.AbilityMultiTargetEffects[Index]);

			if (OriginalBrutalEffect == none)
			{
				continue;
			}

			`Log("Fixing multi target effect for ability" @ TemplateName, default.EnableDebug, 'ChosenBrutalFix');
			`Log("Original effect Will modifier:" @ OriginalBrutalEffect.WillMod, default.EnableDebug, 'ChosenBrutalFix');

			BrutalEffectFix = new class'X2Effect_BrutalFix';
			BrutalEffectFix.WillMod = OriginalBrutalEffect.WillMod;

			AbilityTemplate.AbilityMultiTargetEffects.Remove(Index, 1);
			AbilityTemplate.AddMultiTargetEffect(BrutalEffectFix);

			`Log("New effect Will modifier:" @ BrutalEffectFix.WillMod, default.EnableDebug, 'ChosenBrutalFix');

			break;
		}
	}
}

static function ReplaceBrutalEffectFromItems()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2GrenadeTemplate GrenadeTemplate;
	local X2Effect_BrutalFix BrutalEffectFix;
	local X2Effect_Brutal OriginalBrutalEffect;
	local name TemplateName;
	local int Index;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.BRUTAL_EFFECT_FIX(TemplateName)
	{
		ItemTemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);

		foreach DataTemplates(DataTemplate)
		{
			GrenadeTemplate = X2GrenadeTemplate(DataTemplate);

			if (GrenadeTemplate == none)
			{
				continue;
			}

			for (Index = GrenadeTemplate.ThrownGrenadeEffects.Length - 1; Index >= 0; Index--)
			{
				OriginalBrutalEffect = X2Effect_Brutal(GrenadeTemplate.ThrownGrenadeEffects[Index]);

				if (OriginalBrutalEffect == none)
				{
					continue;
				}

				`Log("Fixing grenade effect for grenade" @ TemplateName, default.EnableDebug, 'ChosenBrutalFix');
				`Log("Original effect Will modifier:" @ OriginalBrutalEffect.WillMod, default.EnableDebug, 'ChosenBrutalFix');

				BrutalEffectFix = new class'X2Effect_BrutalFix';
				BrutalEffectFix.WillMod = OriginalBrutalEffect.WillMod;

				GrenadeTemplate.ThrownGrenadeEffects.Remove(Index, 1);
				GrenadeTemplate.ThrownGrenadeEffects.AddItem(BrutalEffectFix);

				`Log("New effect Will modifier:" @ BrutalEffectFix.WillMod, default.EnableDebug, 'ChosenBrutalFix');

				break;
			}
		}
	}
}
