this.hammer_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hammer_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Notre compagnie est mal préparée à combattre des adversaires en armure. \nNous allons entraîner deux hommes à maîtriser le marteau de combat, et aucun chevalier ne sera à l\'abri de nous.";
		this.m.UIText = "Avoir des hommes avec le talent Maîtrise du Marteau";
		this.m.TooltipText = "Ayez 2 hommes avec le talent Maîtrise du Marteau.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Les hommes se rassemblent pour observer les prouesses de %hammerbrother% alors qu\'il pratique ses coups contre un pin, crack-crack-crack.%SPEECH_ON%Attention à la tête du marteau ! Tu pourrais pratiquement percer n\'importe quel casque et voir ce qu\'il y a à l\'intérieur de cette boîte crânienne !%SPEECH_OFF%Il frappe une fois de plus et le tronc d\'arbre se fend en deux, la partie supérieure tombant directement dans le camp. %nothammerbrother% se lève de son siège, renversant de la soupe sur lui, pour éviter de justesse d\'être écrasé.%SPEECH_ON%Je pensais ne plus rien voir de nouveau dans ce monde, mais je n\'ai jamais tué un homme en faisant tomber un arbre!%SPEECH_OFF%%hammerbrother% crie en riant. Vous pensez que vous vous en sortirez bien la prochaine fois que vous rencontrerez des ennemis lourdement armés.";
		this.m.SuccessButtonText = "Une armure, quelle armure?";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(2, this.getBrosWithMastery()) + "/2)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 2)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 2)
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

			if (p.IsSpecializedInHammers)
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
			this.candiates = not_candidates;
		}

		_vars.push([
			"hammerbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"nothammerbrother",
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

