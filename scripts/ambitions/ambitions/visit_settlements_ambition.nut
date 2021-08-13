this.visit_settlements_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.visit_settlements";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Je sais que la semelle de vos pieds vous démange, et nous devons faire connaître la compagnie.\nRendons visite à tous les villages du monde !";
		this.m.UIText = "Visiter toutes les villes et fortifications du monde";
		this.m.TooltipText = "Entrez dans chaque village, ville, fortification et château du monde pour découvrir leurs biens et services et faire connaître la compagnie.";
		this.m.SuccessText = "[img]gfx/ui/events/event_16.png[/img]Vous découvrez rapidement que l\'envie de voyager dont parlent les bardes n\'est pas aussi répandue qu\'on le dit. Votre décision d\'élargir les horizons de la bande se heurte à la protestation des marches forcées et des nuits sur la route. Mais tous ne se joignent pas aux lamentations.%SPEECH_ON%Si une marche d\'un jour ou une nuit passée sous la pluie vous épuise, comment ferez-vous face à une charge d\'orcs ? %SPEECH_OFF%%sergeantbrother% demande aux hommes, pour obtenir une réponse cinglante. %SPEECH_ON%sec et alerte.%SPEECH_OFF%Vous avez fait claquer le fouet et les avez forcés à le faire. Dans chaque village et ville, vous avez encouragé les hommes à se faire connaître, et ils prennent cette demande à cœur, se bagarrant, s\'évanouissant sur la place publique, menaçant les marchands et harcelant les filles des commerçants. Quoi que les pauvres commerçants et paysans pensent de la compagnie, au moins, ils ne vous oublieront pas de sitôt ! Après avoir voyagé jusqu\'aux limites de ta carte, le nom \"%companyname%\" est plus connu et vous avez acquis une meilleure connaissance du pays.";
		this.m.SuccessButtonText = "N\'oubliez pas le nom, \"%companyname%\" !";
	}

	function getTooltipText()
	{
		if (this.World.Ambitions.getActiveAmbition() == null)
		{
			return this.m.TooltipText;
		}
		else if (!this.onCheckSuccess())
		{
			local ret = this.m.TooltipText + "\n\nIl y a encore quelques colonies à visiter.\n";
			local c = 0;
			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				if (!s.isVisited())
				{
					c = ++c;

					if (c <= 10)
					{
						ret = ret + ("\n- " + s.getName());
					}
					else
					{
						ret = ret + "\n... et d\'autres";
						break;
					}
				}
			}

			return ret;
		}
		else
		{
			local ret = this.m.TooltipText + "\n\nVous avez fait ce que vous aviez prévu de faire.\n";
			return ret;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() == 0 && (this.World.Assets.getOrigin().getID() != "scenario.deserters" || this.World.Assets.getOrigin().getID() != "scenario.raiders"))
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited < 4)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited == 0)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local bestBravery = 0;
		local bravest;

		if (brothers.len() > 1)
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
			if (bro.getCurrentProperties().getBravery() > bestBravery)
			{
				bestBravery = bro.getCurrentProperties().getBravery();
				bravest = bro;
			}
		}

		_vars.push([
			"sergeantbrother",
			bravest.getName()
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

