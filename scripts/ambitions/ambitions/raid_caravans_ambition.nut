this.raid_caravans_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		RaidsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.raid_caravans";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il y a beaucoup de richesses à revendiquer dans les caravanes. Il faut les prendre comme les fruits d\'un arbre !";
		this.m.UIText = "Attaquer des caravanes de commerce ou d\'approvisionnement";
		this.m.TooltipText = "Attaquez 4 caravanes de commerce ou d\'approvisionnement le long de la route. Si vous n\'êtes pas déjà hostile à leur faction, vous pouvez forcer une attaque en maintenant la touche CTRL enfoncée tout en cliquant sur eux avec le bouton gauche de la souris - mais seulement si vous n\'êtes pas actuellement engagé pour un contrat.";
		this.m.SuccessText = "[img]gfx/ui/events/event_60.png[/img]La voix d\'un marchand mort résonne dans votre tête.%SPEECH_ON%Pourquoi avez-vous fait ça ? Nous vous aurions tout donné.%SPEECH_OFF%Mais le souvenir n\'est pas à propos de lui. C\'est à propos de son chariot, et des parties qu\'il ne veut pas divulguer même avec sa vie en jeu. Depuis que vous avez commencé à les attaquer, l\'attaque des caravanes est devenue une sorte de sport pour vous et %companyname%. Enivrés par les richesses de vos embuscades, les hommes sont heureux, et vous avez acquis un peu de renommée pour vos actes ignobles.";
		this.m.SuccessButtonText = "Comme prendre des bonbons à un enfant.";
	}

	function getUIText()
	{
		this.logInfo("to raid: " + this.m.RaidsToComplete);
		this.logInfo("raided: " + this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		local d = 4 - (this.m.RaidsToComplete - this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		return this.m.UIText + " (" + this.Math.min(4, d) + "/4)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") <= 0 && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		this.m.RaidsToComplete = this.World.Statistics.getFlags().getAsInt("CaravansRaided") + 4;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= this.m.RaidsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.RaidsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.RaidsToComplete = _in.readU16();
	}

});

