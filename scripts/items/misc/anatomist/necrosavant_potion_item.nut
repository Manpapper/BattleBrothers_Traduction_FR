this.necrosavant_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.necrosavant_potion";
		this.m.Name = "Potion du Pourchasseur Nocturne";
		this.m.Description = "Celui qui boit cette potion incroyable, produite avec les cendres d'un Necrosavant, se trouvera en possession des pouvoirs de guérison miraculeux des créatures mortes-vivantes ! Cependant, elle ne confère pas la longévité accrue associée aux abominations, bien au contraire. Cela peut être considéré comme une caractéristique si le buveur devient un peu trop à l'aise à boire du sang.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_20.png";
		this.m.Value = 0;
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
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Soigne [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] des dégâts d'impact sur les ennemis adjacents qui ont du sang"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Cliquez avec le bouton droit ou faites glisser sur le personnage actuellement sélectionné pour boire. Cet objet sera consommé dans le processus."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Mutile le corps, provoquant la maladie"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/necrosavant_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

