this.defeat_civilwar_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_civilwar";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Si nous pouvons gagner cette guerre pour l\'une des maisons nobles, notre nom sera inégalé. Choisissons un camp, baignons-nous dans la gloire de la bataille et devenons riches !";
		this.m.UIText = "Mettre fin à la guerre des nobles";
		this.m.TooltipText = "Choisissez une des maisons nobles et travaillez avec elle pour écraser ses ennemis. Chaque armée détruite, et chaque contrat rempli, vous rapprochera de la fin de la guerre.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]À la demande de %winninghouse%, %companyname% a affronté les rangs blindés des autres maisons, un défi apparemment insurmontable. Ce fut une lutte acharnée, contre des adversaires entraînés, disciplinés et bien équipés, mais au final, vous avez vaincu les ennemis de %winninghouse% et triomphé en son nom.\n\nPendant les célébrations qui suivent, %randomnoble%, l\'un des membres les moins importants de %winninghouse%, vous suggère de mettre fin aux festivités plus tôt. Vos hommes sont trop turbulents et il craint qu\'ils ne profitent de l\'hospitalité de sa famille, en partant avec le plateau d\'argent ou en se battant avec le personnel. Il note qu\'il y a déjà eu une fenêtre cassée et montre du doigt des débris de verre sur le sol.\n\nVous répondez que bien que %winninghouse% ait été victorieux, elle est également à ce stade beaucoup plus faible et plus vulnérable que jamais. Ce serait le mauvais moment pour se mettre à dos ses amis... ou pour se faire de nouveaux ennemis. Il prend votre conseil à cœur et la fête continue jusqu\'à l\'aube.";
		this.m.SuccessButtonText = "Qu\'ils nous aiment ou nous détestent, tout le monde connaît %companyname% maintenant !";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Commence";
		}
		else if (f >= 0.5)
		{
			text = "En Cours";
		}
		else if (f >= 0.25)
		{
			text = "Traîne en Longueur";
		}
		else
		{
			text = "Presque Finie";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 1)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local bestRelations = -1.0;
		local best;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() > bestRelations)
			{
				bestRelations = f.getPlayerRelation();
				best = f;
			}
		}
		
		if (best == null)
		{
			return;
		}

		_vars.push([
			"winninghouse",
			best.getName()
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

