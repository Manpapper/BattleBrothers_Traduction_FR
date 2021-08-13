this.allied_civilians_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_civilians";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous avons besoin d\'alliés. En tissant un lien d\'amitié et de confiance avec l\'une des villes, la compagnie obtiendra de meilleurs prix, d\'avantage de volontaires et un travail plus régulier.";
		this.m.UIText = "Atteignez le niveau de relation \"Amical\" avec une faction civile.";
		this.m.RewardTooltip = "En ayant de bonnes relations, vous obtiendrez de meilleurs prix et plus d\'hommes à engager.";
		this.m.TooltipText = "Augmentez vos relations avec une faction civile d\'un village ou d\'une ville du monde à \"Amical\" en remplissant les contrats donnés dans la colonie de la faction. Si vous ne respectez pas les contrats ou si vous trahissez leur confiance, vos relations diminueront. L\'augmentation des relations avec les cités-États prend plus de temps que l\'augmentation des relations avec les petits villages. Les maisons nobles ne comptent pas comme des factions civiles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Décidant que %friendlytown% est un bon endroit pour investir vos efforts, vous décidez d\'offrir la protection de la compagnie et d\'accepter tout travail adapté à vos talents. Vous vous comportez comme un gentleman dans vos relations avec les habitants et vous encouragez les hommes à faire attention à leurs manières lorsqu\'ils sont dans la colonie. Bien sûr, il y a eu quelques protestations au début. %brawler% était très déçu de ne plus pouvoir se battre avec les fermiers, surtout si %companyname% passe autant de temps dans %friendlytown%.\n\nMais vous avez convaincu les hommes qu\'avoir une base d\'opérations amicale est important dans votre métier, car cela signifie obtenir de meilleurs prix sur le marché et plus de personnes prêtes à rejoindre votre groupe hétéroclite. C\'est aussi beaucoup moins fatiguant de ne pas avoir à esquiver la milice tout le temps. Vous avez même enrôlé les hommes pour faire quelques petites tâches en échange de rien d\'autre que de la bonne volonté.%SPEECH_ON%J\'ai trouvé ce petit morveux qui s\'était égaré et je l\'ai ramené à la maison.%SPEECH_OFF%%randombrother% se vante, rapidement surpassé par %randombrother2%.%SPEECH_ON% Je suis allé au marché pour la vieille dame, j\'ai fendu son bois de chauffage pour l\'hiver, et j\'ai même sorti son linge, mais ma limite s\'arrête au sauvetage des chats dans les arbres.%SPEECH_OFF%.";
		this.m.SuccessButtonText = "Cela nous aidera.";
	}

	function onUpdateScore()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
			{
				this.m.IsDone = true;
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
			{
				_vars.push([
					"friendlytown",
					f.getName()
				]);
				break;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler")
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground())
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		_vars.push([
			"brawler",
			brothers[this.Math.rand(0, brothers.len() - 1)].getName()
		]);
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

