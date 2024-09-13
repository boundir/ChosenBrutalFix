class X2Effect_BrutalFix extends X2Effect;

var int WillMod;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local int CurrentWill;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if (TargetUnit != none)
	{
		CurrentWill = TargetUnit.GetCurrentStat(eStat_Will);

		if (CurrentWill + WillMod <= 0)
		{
			TargetUnit.SetCurrentStat(eStat_Will, 1);
		}
		else
		{
			TargetUnit.SetCurrentStat(eStat_Will, CurrentWill + WillMod);
		}

		`Log(TargetUnit.GetFullName() @ "lost" @ WillMod @ "will and is now at" @ TargetUnit.GetCurrentStat(eStat_Will), class'X2DLCInfo_ChosenBrutalFix'.default.EnableDebug, 'ChosenBrutalFix');
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int WillChange;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		WillChange = NewUnit.GetCurrentStat(eStat_Will) - OldUnit.GetCurrentStat(eStat_Will);

		`Log(WillChange @ "will loss on" @ NewUnit.GetFullName() , class'X2DLCInfo_ChosenBrutalFix'.default.EnableDebug, 'ChosenBrutalFix');

		if (WillChange != 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(class'X2Effect_Brutal'.default.WillChangeMessage, "<WillChange/>", WillChange);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Bad);
		}
	}
}