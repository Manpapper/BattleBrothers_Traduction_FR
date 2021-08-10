this.defeat_mercenaries_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0,
		OtherMercs = ""
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_mercenaries";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "La meilleure façon de prouver que nous sommes la compagnie la plus forte\n du coin est de vaincre une autre bande de mercenaires au combat !";
		this.m.UIText = "Vaincre une autre compagnie de mercenaires";
		this.m.TooltipText = "Vaincre une autre compagnie de mercenaires qui parcourt les terres. Si vous n\'avez pas d\'ennemis susceptibles d\'engager une autre compagnie de mercenaires, vous pouvez toujours appuyer sur CTRL + Clic gauche pour attaquer n\'importe qui - à condition que vous ne soyez pas actuellement employé.";
		this.m.SuccessText = "[img]gfx/ui/events/event_87.png[/img]%randombrother% essuie la sueur et le sang sur son front.%SPEECH_ON%Ce tas de tricheurs ! Je pensais que j\'étais le seul à connaître ce truc !%SPEECH_OFF%Les mercenaires sont un groupe hétéroclite et imprévisible par nature, avec un équipement bizarre, des compétences et une expérience très variables, et des tactiques astucieuses. En l\'absence de normes pour leurs membres, ils peuvent n\'être rien de plus qu\'une bande de vieux commerçants en quête d\'aventure. Mais là encore, vous pourriez être surpris par un groupe de vétérans de la campagne. Pire encore, ils ne suivent aucune règle. La %defeatedcompany% a fait de son mieux, mais bien qu\'elle connaisse les mêmes stratagèmes astucieux que vos compagnons, elle n\'a pas fait le poids face à %companyname%.\n\nVotre victoire montrera sûrement aux employeurs du monde entier quelles sont les lames les plus affûtées.";
		this.m.SuccessButtonText = "Manger et être mangé.";
	}

	function onPartyDestroyed( _party )
	{
		if (_party.getFlags().has("IsMercenaries"))
		{
			++this.m.Defeated;
			this.m.OtherMercs = _party.getName();
		}

		this.World.Ambitions.updateUI();
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.Defeated >= 1)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"defeatedcompany",
			this.m.OtherMercs
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
		_out.writeString(this.m.OtherMercs);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
		this.m.OtherMercs = _in.readString();
	}

});

