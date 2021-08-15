this.have_all_provisions_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_all_provisions";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Je sais que vous êtes fatigués de notre mauvaise fortune et de nos plats rassis jour après jour. Nous allons donc chercher de la nourriture et des boissons dans tout le pays et faire un festin !";
		this.m.RewardTooltip = "Améliore significativement l\'humeur de vos hommes.";
		this.m.UIText = "Ayez une provision de chaque type existant";
		this.m.TooltipText = "Ayez une provision de chaque type dans votre réserve pour organiser un festin.";
		this.m.SuccessText = "[img]gfx/ui/events/event_61.png[/img]Après avoir fait le tour des fournisseurs et marchandé avec les agriculteurs, vous avez rassemblé une sélection de denrées alimentaires qui attirerait l\'attention du noble le plus endurci. Le garde-manger rempli, vous organisez un festin pour %companyname% et invitez chaque homme à manger à sa faim. Vos frères d\'armes ne perdent pas de temps. Ce qui leur manque en manières, ils le compensent en appétit. %randombrother% profite de l\'occasion pour partager ses connaissances sur la viande.%SPEECH_ON%Cette bête est morte avec de la joie dans le cœur, c\'est pour cela qu\'elle est si tendre.%SPEECH_OFF%Devant l\'admiration de ses camarades, %strongest_brother% fait un rot tonitruant. Après cela, il n\'y a pas beaucoup de conversation, mais les barbes grasses et les ventres pleins garantissent que les hommes seront de bonne humeur pour votre prochain combat.";
		this.m.SuccessButtonText = "Les hommes l\'ont mérité.";
	}

	function getTooltipText()
	{
		if (this.hasAllProvisions())
		{
			return this.m.TooltipText;
		}

		local fish = false;
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		local ret = this.m.TooltipText + "\n\nIl vous manque actuellement certaines provisions.\n";

		if (!beer)
		{
			ret = ret + "\n- Bière";
		}

		if (!bread)
		{
			ret = ret + "\n- Pain";
		}

		if (!cured_venison)
		{
			ret = ret + "\n- Gibier Séché";
		}

		if (!dried_fish)
		{
			ret = ret + "\n- Poisson Séché";
		}

		if (!dried_fruits)
		{
			ret = ret + "\n- Fruits Secs";
		}

		if (!ground_grains)
		{
			ret = ret + "\n- Céréales Moulues";
		}

		if (!goat_cheese)
		{
			ret = ret + "\n- Fromage de Chèvre";
		}

		if (!mead)
		{
			ret = ret + "\n- Hydromel";
		}

		if (!mushrooms)
		{
			ret = ret + "\n- Champignons";
		}

		if (!berries)
		{
			ret = ret + "\n- Racines et Baies";
		}

		if (!smoked_ham)
		{
			ret = ret + "\n- Jambon Fumé";
		}

		if (!wine)
		{
			ret = ret + "\n- Vin";
		}

		if (!cured_rations)
		{
			ret = ret + "\n- Rations Traitées";
		}

		if (this.Const.DLC.Desert)
		{
			if (!dates)
			{
				ret = ret + "\n- Dattes";
			}

			if (!rice)
			{
				ret = ret + "\n- Riz";
			}

			if (!dried_lamb)
			{
				ret = ret + "\n- Agneau Séché";
			}
		}

		return ret;
	}

	function hasAllProvisions()
	{
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		if (!this.Const.DLC.Desert)
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations;
		}
		else
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations && dates && rice && dried_lamb;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getAverageMoodState() > this.Const.MoodState.Concerned)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.hasAllProvisions())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.hasAllProvisions())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.improveMood(1.0, "Un festin avec la compagnie");
		}
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

