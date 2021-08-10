this.armor_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.armor";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous équiperons un contingent d\'au moins trois hommes avec des\n armures lourdes pour servir de rempart contre les adversaires dangereux.";
		this.m.UIText = "Avoir 3 pièces d\'armure et casques avec une durabilité de 230+.";
		this.m.TooltipText = "Ayez 3 pièces d\'armure et 3 casques, chacun avec une durabilité de 230 ou plus. Que vous les achetiez ou que vous les pilliez sur le champ de bataille, ils protégeront vos hommes de la même manière.";
		this.m.SuccessText = "[img]gfx/ui/events/event_35.png[/img]L\'humeur général augmente avec l\'acquisition de plus d\'armures lourdes et de casques pour %companyname%.%SPEECH_ON%Vous voyez ça ? C\'est de l\'artisanat. %SPEECH_OFF%%randombrother% dit, en frappant un pommeau de bois dur contre la tête nouvellement blindée de son frère d\'armes.%SPEECH_ON%Pensez à tous les contrats bien payés que nous avons ratés à cause de notre armure minable et de notre équipement pathétique. %SPEECH_OFF%Désormais, la ligne arrière peut respirer plus facilement au combat, sachant que leurs compagnons lourdement armés seront là pour prendre le gros de l\'assaut. S\'ils tombent, leur masse encombrante retardera au moins l\'ennemi, donnant à leurs camarades légèrement protégés une chance de se retirer rapidement.";
		this.m.SuccessButtonText = "Cela nous servira dans les batailles à venir.";
	}

	function getArmor()
	{
		local ret = {
			Armor = 0,
			Helmet = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null)
			{
				if (item.isItemType(this.Const.Items.ItemType.Armor) && item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet) && item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 40)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local armor = this.getArmor();

		if (armor.Armor >= 3 || armor.Helmet >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local armor = this.getArmor();

		if (armor.Armor >= 3 && armor.Helmet >= 3)
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

