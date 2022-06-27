this.gain_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.gain_addiction";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{En criant et en hurlant, %other% traîne %addict% dans votre tente, le fait tomber, le menace avec son arme, l\'homme regarde autour de lui, hébété et confus. Vous exigez de savoir ce qui se passe. %addict% repousse l\'arme qu\'il a devant lui et tente de se relever, mais %other% le renvoie au sol d\'un coup de pied.%SPEECH_ON%Les gars se sont enrichis avec les potions, capitaine. On peut difficilement le tenir à l\'écart du stock.%SPEECH_OFF%%addict% bafouille, grogne et fait des pauses, puis hoche la tête. Il parle clairement, comme un ivrogne qui tente d\'expliquer son crime à la garde.%SPEECH_ON%Je n\'ai pas de problème, monsieur.%SPEECH_OFF%Vous vous levez et vérifiez le front de l\'homme. Il est froid mais trempé de sueur. %other% crache.%SPEECH_ON%Il deviendra un peu violent si vous le confrontez au sujet des potions, monsieur. Je pense qu\'il est accro à ces maudites choses.%SPEECH_OFF%Vous hochez la tête et dites aux deux de rester au maximum de leurs capacités. | %addict% entre dans votre tente avec de la sueur sur le front et des yeux noirs.%SPEECH_ON%Monsieur, j\'ai pensé que je devais vous le dire personnellement, vous savez, pour assumer l\'entière responsabilité.%SPEECH_OFF%Il explique qu\'il est devenu dépendant aux potions. Il dit qu\'il fera de son mieux pour s\'en sortir. Vous acquiescez et le remerciez pour son honnêteté. La nouvelle vous inquiète, mais il n\'y a guère de solutions pour l\'instant. | Les hommes expliquent que %addict% a pris goût aux potions, aux fioles et aux flacons, ceux qui transportent les esprits au-delà de la bonne bière et de l\'hydromel. Vous ne savez pas si c\'est à cause d\'un usage excessif ou parce qu\'il a du mal à gérer les difficultés du métier de mercenaire. Vous dites à quelques hommes de garder un oeil sur lui. C\'est le mieux que vous puissiez faire pour le moment.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La route est épuisante, mais les hommes y parviendront-ils ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = this.new("scripts/skills/traits/addict_trait");
				_event.m.Addict.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " est maintenant dépendant"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionsUsed") >= 4 && this.Time.getVirtualTimeF() - bro.getFlags().get("PotionLastUsed") <= 3.0 * this.World.getTime().SecondsPerDay)
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

