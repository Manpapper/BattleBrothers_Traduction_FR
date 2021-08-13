this.named_item_set_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.named_item_set";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Une compagnie renommée se reconnaît à son équipement. Nous devrions nous rendre sur place et réclamer une arme, un bouclier, une armure et un casque prestigieux pour accroître notre renommée.";
		this.m.UIText = "Avoir une arme, un bouclier, une armure et un casque célèbres.";
		this.m.TooltipText = "Ayez au moins une arme, un bouclier, une armure et un casque célèbre chacun en votre possession. Suivez les rumeurs dans les tavernes pour savoir où trouver des objets célèbres, achetez-les dans les boutiques spécialisées des grandes villes et des châteaux, ou partez seul pour explorer et piller des ruines et des camps. Plus vous vous éloignez de la civilisation, plus vous avez de chances de trouver des objets rares.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Après des semaines passées à écouter les rumeurs, à acheter des pintes de bière à de vieux vétérans décrépits et à négocier avec des femmes pleurnichardes, vous avez réussi à découvrir l\'emplacement d\'une arme, d\'un bouclier, d\'une armure et d\'un casque prestigieux. Ayant appris où trouver les pièces, il ne restait plus qu\'à vaincre les diverses horreurs et égorgeurs qui les gardaient. Bientôt portées par les hommes de votre compagnie, les pièces forment un ensemble redoutable à voir.%SPEECH_ON%L\'homme qui portera cette armure sur le champ de bataille verra l\'ennemi le plus féroce s\'en aller en courant!%SPEECH_OFF%%randombrother% s\'exclame fièrement et avec l\'approbation rieuse de ses frères d\'armes. Il ne reste plus qu\'à espérer que leur joie et leur excitation ne se transforment pas en jalousie lorsque vous annoncerez qui portera les pièces.";
		this.m.SuccessButtonText = "Cela nous servira bien.";
	}

	function getNamedItems()
	{
		local ret = {
			Weapon = false,
			Shield = false,
			Armor = false,
			Helmet = false,
			Items = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					++ret.Items;

					if (item.isItemType(this.Const.Items.ItemType.Weapon))
					{
						ret.Weapon = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Shield))
					{
						ret.Shield = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Armor))
					{
						ret.Armor = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Helmet))
					{
						ret.Helmet = true;
					}
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 50)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 5)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local named = this.getNamedItems();

		if (named.Items == 0)
		{
			return;
		}

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local named = this.getNamedItems();

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
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

