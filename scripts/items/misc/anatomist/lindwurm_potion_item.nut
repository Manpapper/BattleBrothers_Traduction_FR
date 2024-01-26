this.lindwurm_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lindwurm_potion";
		this.m.Name = "Teinture de Sangembrasé";
		this.m.Description = "Sentez votre sang bouillonner ! Ou, pour être plus précis, non ! Avec cette teinture, le sang brûlant d'un lindwurm coulera à travers des veines décidément humaines, le sujet chanceux n'y verrait que du feu. Jusqu'à ce qu'il commence à saigner, bien sûr.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_27.png";
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
			text = "Fait brûler le sang d'un personnage avec de l'acide, infligeant des dégâts aux attaquants en mêlée chaque fois qu'ils infligent des dégâts aux points de vie"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/lindwurm_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

