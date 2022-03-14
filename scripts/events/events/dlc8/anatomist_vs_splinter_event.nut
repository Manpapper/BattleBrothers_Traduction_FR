this.anatomist_vs_splinter_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		SplinterBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_splinter";
		this.m.Title = "During camp...";
		this.m.Cooldown = 110.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{You find %anatomist% holding up the barefoot of %splinterbro%. Naturally, you inquire just what they\'re doing. The anatomist straightens up with a tweezer in hand and pinched between its prongs is a huge splinter. %splinterbro% wiggles his toes then gets to his feet. He walks around, then quickly plants his foot and pivots and walks backwards and forwards.%SPEECH_ON%I\'ll be damned. I thought I\'d just busted my foot or somethin\', turns out I\'d just been walking around with a huge arsed splinter for years! This feels great!%SPEECH_OFF%Instead of throwing the splinter away, %anatomist% confines it to a wooden box where other medical oddities are rolling around.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I best not see you using that as a toothpick.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.SplinterBro.getImagePath());
				_event.m.SplinterBro.getBaseProperties().MeleeDefense += 1;
				_event.m.SplinterBro.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.SplinterBro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Melee Defense"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local splinter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.monk" || bro.getBackground().getID() != "background.historian" || bro.getBackground().getID() != "background.adventurous_noble" || bro.getBackground().getID() != "background.disowned_noble" || bro.getBackground().getID() != "background.regent_in_absentia" || bro.getBackground().getID() != "background.minstrel")
			{
				splinter_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || splinter_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.SplinterBro = splinter_candidates[this.Math.rand(0, splinter_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"splinterbro",
			this.m.SplinterBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.SplinterBro = null;
	}

});

