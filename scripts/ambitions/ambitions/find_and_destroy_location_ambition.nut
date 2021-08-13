this.find_and_destroy_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.find_and_destroy_location";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Partons dans le désert, découvrons l\'inconnu et pillons-le. Qu\'il s\'agisse de la tombe d\'un sorcier, d\'un camp de gobelins ou de toute autre chose que nous pourrions trouver.";
		this.m.UIText = "Découvrir une ruine ou un camp hostile, et le détruire.";
		this.m.TooltipText = "Découvrez une ruine, un camp ou tout autre lieu hostile par vous-même en explorant le monde, détruisez-le et prenez le butin.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Cela semblait être une bonne idée à l\'époque, mais marcher dans la nature sans carte ni destination en tête s\'est avéré être un moyen assez difficile de trouver des richesses, ou même une bataille. Mais votre groupe a fini par tomber sur une cible valable, et tout le monde a reconnu que l\'aventure en valait la peine après tout. %farmer% est presque rayonnant de satisfaction alors qu\'il observe les quelques braises restantes de %recently_destroyed%.%SPEECH_ON%Ils n\'avaient pas le moindre soupçon que nous arrivions. Comme le blé devant nos faux, mes frères!%SPEECH_OFF%%notfarmer% lève un sourcil.%SPEECH_ON% Parle pour toi. Je ne suis pas un fermier.%SPEECH_OFF%";
		this.m.SuccessButtonText = "Un autre défi relevé.";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local farmers = [];
		local workers = [];
		local not_farmers = [];

		if (brothers.len() > 2)
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
			if (bro.getBackground().getID() == "background.farmhand")
			{
				farmers.push(bro);
			}
			else if (bro.getBackground().getID() == "background.shepherd" || bro.getBackground().getID() == "background.miller" || bro.getBackground().getID() == "background.daytaler")
			{
				workers.push(bro);
			}
			else
			{
				not_farmers.push(bro);
			}
		}

		local farmer;

		if (farmers.len() != 0)
		{
			farmer = farmers[this.Math.rand(0, farmers.len() - 1)];
		}
		else if (workers.len() != 0)
		{
			farmer = workers[this.Math.rand(0, workers.len() - 1)];
		}
		else
		{
			farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		local not_farmer;

		if (not_farmers.len() != 0)
		{
			not_farmer = not_farmers[this.Math.rand(0, not_farmers.len() - 1)];
		}
		else
		{
			not_farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"farmer",
			farmer.getName()
		]);
		_vars.push([
			"notfarmer",
			not_farmer.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
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

