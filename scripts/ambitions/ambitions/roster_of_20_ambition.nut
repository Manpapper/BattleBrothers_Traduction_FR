this.roster_of_20_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_20";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Renforçons nos effectifs jusqu\'à vingt hommes valides pour que les blessés puissent\nse reposer et que les fatigués reprennent des forces entre les escarmouches.";
		this.m.UIText = "Avoir un groupe d\'au moins 20 hommes";
		this.m.TooltipText = "Engagez suffisamment d\'hommes pour avoir un effectif complet de 20 hommes. Visitez les colonies à travers le pays pour trouver des recrues qui répondent à vos besoins.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Pendant plusieurs jours, vous avez parlé avec des recrues potentielles de différents milieux et de tous les coins de la société, éliminant les incompétents et marchandant avec les cupides. Il semble qu\'en ces temps troublés, tous les vagabonds, les marchands  et les fils cadets des nobles souhaitent devenir mercenaires.\n\nLes hommes sont heureux d\'avoir un plus grand nombre de recrues au sein de la compagnie, et ceux que vous avez rejetés seront la cible de nombreuses plaisanteries pendant les semaines à venir. %highestexperience_brother% vous tape sur l\'épaule.%SPEECH_ON%Qu\'en est-il de cet homme qui a dit qu\'il avait pris les têtes d\'une bande d\'orcs, mais qui était en fait un boulanger de %randomtown% ! Pincer des biceps flasques et frapper des fils de fermiers avec des branches d\'arbres était un bon sport les premiers jours mais à la fin, c\'était plus de travail que de chasser des brigands, si vous voulez mon avis.%SPEECH_OFF%Vous avez maintenant vingt hommes sous votre commandement. Tous ne sont pas des vétérans, et tous n\'ont pas été testés, mais le fait de pouvoir faire la rotation de vos blessés signifie des unités plus fraîches sur le terrain.";
		this.m.SuccessButtonText = "Une compagnie complète, enfin.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.m.IsDone = true;
			return;
		}

		if (this.World.Assets.getBrothersMax() < 20)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.roster_of_12").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

