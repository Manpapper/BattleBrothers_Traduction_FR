this.spiritual_reward_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.spiritual_reward";
		this.m.Name = "Fiole bleue";
		this.m.Description = "Échangé avec une sorcière malveillante au détriment de la vie d\'un autre homme, cette mystérieuse concoction promet d\'être une boisson magique pour l\'esprit, et de donner sagesse et perspicacité comme si il avait livré une douzaine de batailles.";
		this.m.Icon = "consumables/vial_blue_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2500;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Accorde un niveau supérieur de vétéran"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Faites un clic droit ou faites glisser sur le personnage actuellement sélectionné pour boire. Cet article sera consommé au cours du processus."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		_actor.m.LevelUps += 1;
		_actor.fillAttributeLevelUpValues(1, false, true);
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});

