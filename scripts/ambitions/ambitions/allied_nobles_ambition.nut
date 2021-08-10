this.allied_nobles_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_nobles";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous devons gagner la confiance d\'une maison noble et devenir leur allié. Ils partageront \nsûrement leurs armureries bien remplies avec de bons amis.";
		this.m.RewardTooltip = "Vous recevrez un équipement unique de la maison noble avec laquelle vous vous alliez.";
		this.m.UIText = "Atteignez le niveau de relation \"Allié\" avec une maison noble.";
		this.m.TooltipText = "Augmentez vos relations avec n\'importe quelle maison noble à \"Allié\" en remplissant les contrats donnés par les membres de la faction. Si vous ne respectez pas les contrats ou si vous trahissez leur confiance, vos relations diminueront.";
		this.m.SuccessText = "[img]gfx/ui/events/event_78.png[/img]Vous avez longtemps entendu dire, et appris par l\'expérience que c\'était vrai, que les nobles sont difficiles et inconstants, mais votre relation avec %noblehouse% s\'avère profitable et même agréable. Ils ne vous considèrent peut-être pas comme des égaux lorsque tout le monde est assis à un festin, mais ils ne sont pas non plus vos égaux sur le champ de bataille. Après avoir gagné leur confiance à force de travail et d\'engagement, %companyname% a finalement été reconnue comme un allié de confiance de %noblehouse%.\n\nUn des avantages de ce poste est que vos hommes ont le droit de parcourir l\'armurerie de la noblesse. Quelques partisans aigris peuvent vous traiter de chiens de faïence pour vous être alliés à la noblesse, et présenter leurs bannières sur vos boucliers, mais jamais en face de vous.";
		this.m.SuccessButtonText = "Excellent.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local hasFriend = false;
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse)
			{
				if (f.getPlayerRelation() >= 90.0)
				{
					return;
				}
				else if (f.getPlayerRelation() >= 60.0)
				{
					hasFriend = true;
				}
			}
		}

		if (!hasFriend)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
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

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
			{
				_vars.push([
					"noblehouse",
					f.getName()
				]);
				break;
			}
		}
	}

	function onReward()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local banner = 1;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
			{
				banner = f.getBanner();
				break;
			}
		}

		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/helmets/faction_helm");
		item.setVariant(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/armor/special/heraldic_armor");
		item.setFaction(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
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

