this.oldguard_becomes_drunkard_event <- this.inherit("scripts/events/event", {
	m = {
		Oldguard = null,
		Casualty = null,
		OtherCasualty = null
	},
	function create()
	{
		this.m.ID = "event.oldguard_becomes_drunkard";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]Vous trouvez %oldguard% en train de soigner une assez grande chope près d\'un feu. En fait, ce n\'est pas du tout une chope, mais un seau en bois rempli de bière. Quelques chopes plus modestes sont éparpillées à ses pieds. Il se penche en arrière, et boit à petites gorgées depuis le bord du seau. Quand il vous voit, il essaie de se mettre sur son 31, en enlevant la mousse de son visage et en tentant un sourire qui se transforme rapidement en un froncement de sourcils d\'ivrogne.%SPEECH_ON%Salut, capitaine. Je ne voulais pas que vous me voyiez comme ça.%SPEECH_OFF%Vous vous installez près de l\'homme et lui demandez comment il va.%SPEECH_ON%Ivre.%SPEECH_OFF%En hochant la tête, vous tendez la main vers le seau et l\'homme vous le tend, bien que ses mains soient serrés comme s\'il le tenait encore. Vous posez le seau et lui demandez à nouveau comment il va. Il finit par laisser tomber ses mains sur ses genoux.%SPEECH_ON%Comme une merde. C\'est ce que je ressens. D\'abord, %casualty% est tombé. Puis %autrecasualty%. Je sais qu\'il y en a eu au moins cinq ou six autres. Juste des hommes morts. Venus et partis. Je me souviens d\'eux en train de parler, et d\'eux en train de crier, et je ne peux pas avoir l\'un sans l\'autre. Mais je vais bien maintenant, parce que je n\'arrive pas à penser correctement. Si je ne peux pas désapprendre un souvenir, je vais juste aller de l\'avant et le noyer. La bière me fait du bien, heh.%SPEECH_OFF%Avec un soupir, vous rendez le seau à l\'homme. Les yeux perdus dans le feu, l\'esprit perdu dans le passé, il ne dit rien d\'autre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux amis absents...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oldguard.getImagePath());
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Oldguard.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Oldguard.getName() + " est devenu un ivrogne"
				});
				_event.m.Oldguard.worsenMood(1.0, "A perdu trop d\'amis");

				if (_event.m.Oldguard.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oldguard.getMoodState()],
						text = _event.m.Oldguard.getName() + this.Const.MoodStateEvent[_event.m.Oldguard.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 7)
		{
			return;
		}

		local numFallen = 0;

		foreach( f in fallen )
		{
			if (!f.Expendable)
			{
				numFallen = ++numFallen;
			}
		}

		if (numFallen < 7)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getLevel() >= 8 && !bro.getSkills().hasSkill("trait.drunkard") && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[0].Time && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[1].Time && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oldguard = candidates[this.Math.rand(0, candidates.len() - 1)];

		for( local i = 0; i < fallen.len(); i = ++i )
		{
			if (fallen[i].Expendable)
			{
			}
			else if (this.m.OtherCasualty == null)
			{
				this.m.OtherCasualty = fallen[i].Name;
			}
			else if (this.m.Casualty == null)
			{
				this.m.Casualty = fallen[i].Name;
			}
			else
			{
				break;
			}
		}

		this.m.Score = numFallen - 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Oldguard.getName()
		]);
		_vars.push([
			"casualty",
			this.m.Casualty
		]);
		_vars.push([
			"othercasualty",
			this.m.OtherCasualty
		]);
	}

	function onClear()
	{
		this.m.Oldguard = null;
		this.m.Casualty = null;
		this.m.OtherCasualty = null;
	}

});

