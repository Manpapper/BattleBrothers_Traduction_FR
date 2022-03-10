this.fountain_of_youth_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.bodily_reward";
		this.m.Name = "Outre de jouvence";
		this.m.Description = "Une outre en cuir remplie d\'un liquide sous un arbre étrange de forme humaine. Il a murmuré dans votre tête que vous devriez le boire pour guérir.";
		this.m.Icon = "consumables/youth_01.png";
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
			text = "Supprime toutes les blessures temporaires ou permanentes, ainsi que les traits et effets de statut Ancien, Accro, Épuisé et Gueule de bois"
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
		if (!_actor.getSkills().hasSkillOfType(this.Const.SkillType.Injury) && !_actor.getSkills().hasSkill("trait.old"))
		{
			return false;
		}

		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().removeByType(this.Const.SkillType.Injury);
		_actor.getSkills().removeByID("trait.old");
		_actor.getSkills().removeByID("trait.addict");
		_actor.getSkills().removeByID("effects.hangover");
		_actor.getSkills().removeByID("effects.exhausted");
		_actor.setHitpoints(_actor.getHitpointsMax());
		_actor.getFlags().set("PotionsUsed", 0);
		_actor.getFlags().set("IsRejuvinated", true);
		_actor.getSprite("permanent_injury_1").Visible = false;
		_actor.getSprite("permanent_injury_2").Visible = false;
		_actor.getSprite("permanent_injury_3").Visible = false;
		_actor.getSprite("permanent_injury_4").Visible = false;
		_actor.getSprite("permanent_injury_1").resetBrush();
		_actor.getSprite("permanent_injury_2").resetBrush();
		_actor.getSprite("permanent_injury_3").resetBrush();
		_actor.getSprite("permanent_injury_4").resetBrush();
		return true;
	}

});

