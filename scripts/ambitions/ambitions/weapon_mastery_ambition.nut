this.weapon_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.weapon_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Imaginez la terreur que nous pourrions faire régner si vos compétences étaient à la hauteur de votre courage.\nNous allons entraîner cinq hommes à maîtriser leurs armes pour qu\'ils puissent servir d\'avant-garde !";
		this.m.UIText = "Avoir des hommes ayant chacun une maîtrise d\'arme";
		this.m.TooltipText = "Ayez 5 de vos hommes avoir chacun une maîtrise d\'arme, peu importe laquel.";
		this.m.SuccessText = "[img]gfx/ui/events/event_50.png[/img]Introduire un nouveau régime pour entraîner les mercenaires à la maîtrise d\'une arme est bon pour le moral de tous. Ceux qui s\'entraînent améliorent leurs prouesses et leurs chances de survie, et gagnent l\'admiration de leurs compagnons, tandis que les autres ont quelque chose d\'amusant à regarder en s\'asseyant sur une bûche et en se gavant de mouton.\n\nLes apprentis s\'entraînent à chaque moment libre avec une variété d\'armes jusqu\'à ce que leurs bras deviennent durs comme des branches de chêne, et que leurs yeux aiguisés deviennent aussi vifs et impitoyables que ceux d\'un grand chat%SPEECH_ON%Non seulement %weaponbrother% est une menace redoutable pour nos ennemis, mais son jeu de jambes rapide vous fait penser à une danseuse.%SPEECH_OFF%%notweaponbrother% remarque, seulement pour se faire châtier avec une épée d\'entraînement par %weaponbrother%.";
		this.m.SuccessButtonText = "Ce sont des professionnels maintenant.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(5, this.getBrosWithMastery()) + "/5)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInThrowing)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSwords)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCleavers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInMaces)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInAxes)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInFlails)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSpears)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInPolearms)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInDaggers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 5)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local not_candidates = [];

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
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCrossbows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInThrowing)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSwords)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCleavers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInMaces)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInHammers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInAxes)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInFlails)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSpears)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInPolearms)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInDaggers)
			{
				candidates.push(bro);
			}
			else
			{
				not_candidates.push(bro);
			}
		}

		if (not_candidates.len() == 0)
		{
			not_candidates = brothers;
		}

		_vars.push([
			"weaponbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"notweaponbrother",
			not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
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

