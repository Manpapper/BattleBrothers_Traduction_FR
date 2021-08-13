this.win_against_x_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_x";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Mettons de côté les escarmouches pour le moment et cherchons à vaincre un groupe d\'au moins une douzaine d\'adversaires. C\'est ainsi que notre nom sera connu dans tout le pays !";
		this.m.RewardTooltip = "Gagnez 150 de renom supplémentaire pour votre réussite.";
		this.m.UIText = "Gagner une bataille contre 12 ennemis ou plus";
		this.m.TooltipText = "Gagnez une bataille contre 12 ennemis ou plus, que ce soit en les tuant ou en les faisant se disperser et fuir. Vous pouvez le faire dans le cadre d\'un contrat ou en vous battant à votre guise.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Alors que tous vos ennemis sont morts ou ont battu en retraite, %bravest_brother% brandit la bannière de la compagnie en signe de célébration.%SPEECH_ON%Une fois de plus %companyname% a combattu, et une fois de plus %companyname% a vaincu!%SPEECH_OFF%Des acclamations bruyantes lui font écho tout autour. Vous découvrez bientôt que votre récente bataille est le sujet de conversation des villes et villages locaux. Chaque fois qu\'ils s\'arrêtent dans une taverne le long de la route, les mercenaries constatent que les boissons sont versées lorsque l\'histoire de cette bataille est racontée, et plus le récit est embelli, plus les boissons coulent à flots.";
		this.m.SuccessButtonText = "Qui osera se dresser contre nous maintenant ?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onReward()
	{
		this.World.Assets.addBusinessReputation(150);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Vous recevez un renom supplémentaire pour votre victoire"
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeBool(this.m.IsFulfilled);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.IsFulfilled = _in.readBool();
	}

});

