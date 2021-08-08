this.hedge_knight_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%raider% est assis à côté du feu de camp, le regard plongé dans les flammes. Il y a quelques instants, on a entendu un couple d\'hommes lui crier dessus. Son passé de pillard ne lui a pas valu beaucoup d\'amis. Le chevalier errant, %hedgeknight%, s\'approche et se tient à ses côtés. Alors que les deux hommes échangent un regard, vous avez soudain peur qu\'une bagarre que vous ne pouvez pas arrêter n\'éclate. Au lieu de cela, le chevalier errant s\'assied. Il parle calmement, bien que sa voix profonde soit toujours aussi effrayante.%SPEECH_ON%Vous avez fait des raids sur les côtes, non? Tué des femmes et des enfants ? Volé le clergé ?%SPEECH_OFF%Le pillard acquiesce.%SPEECH_ON%Oui, et pire encore.%SPEECH_OFF%%hedgeknight% ramasse un morceau de bois fumant dans le feu. Il l\'écrase dans sa main, les flammes se transforment en cendres et en fumée. Il le laisse s\'effriter dans sa paume calleuse.%SPEECH_ON%Tu ne devrais pas te soucier de ce que les autres disent, Pilleur. C\'est un monde méchant et avide, et vous vous occupez bien de ses dents. Laisse les faibles crier et mourir. Nous ne pouvons nous blinder que par notre propre existence, enveloppés dans l\'envie des morts qui écraseraient volontiers le crâne d\'un enfant pour une simple gorgée du souffle de nos poumons.%SPEECH_OFF%Le pillard prend son propre morceau de bois de chauffage et le broie. Ils se serrent la main et ne disent plus rien.",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce monde favorise les forts.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());
				_event.m.HedgeKnight.improveMood(1.0, "S\'est lié à " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
					text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
				});
				_event.m.Raider.improveMood(1.0, "S\'est lié à " + _event.m.HedgeKnight.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Raider.getMoodState()],
					text = _event.m.Raider.getName() + this.Const.MoodStateEvent[_event.m.Raider.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local hedge_knight_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Raider = null;
	}

});

