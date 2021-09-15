this.wound_gets_infected_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null,
		Other = null,
		WoundName = ""
	},
	function create()
	{
		this.m.ID = "event.wound_gets_infected";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_34.png[/img]{Vous découvrez %woundedbrother% évanoui dans l\'herbe et il n\'y a pas d\'hydromel ou de bière à côté de lui, ce qui aurait pu être un indice. En vous accroupissant, vous voyez que ses yeux sont éteints et qu\'il ne répond pas aux questions. Sa poitrine se soulève et s\'abaisse en raison d\'une respiration irrégulière. Vous décollez les pansements sur sa %blessure% pour révéler une chair verte et maladive. | %woundedbrother% est en train de rire avec le reste des hommes quand il tombe soudain à la renverse, les yeux à l\'arrière de la tête. Les autres hommes se précipitent à son secours.%SPEECH_ON%Capitaine, sa blessure est plus que douloureuse.%SPEECH_OFF%La chair autour de sa %wound% est devenue pulpeuse, recouverte de peaux mortes et du pus sortant des infections prêtes à être éliminées. | La %blessure% de %wound% s\'est infectée. La chair autour de la blessure est noire et celle qui a de la couleur est verte, deux très mauvais signes. | L\'infection s\'installe dans la %blessure% de %woundedbrother%. On ne peut pas dire s\'il survivra ou non, mais de toute façon, il sera en mauvais état pendant un certain temps. | Vous trouvez %woundedbrother% appuyé contre un arbre. Il tremble et de la salive coule de ses lèvres.%SPEECH_ONJe vais bien, monsieur. Ma \"blessure\" est juste... un peu infectée. Donnez-moi du temps, je vais aller mieux.%SPEECH_OFF% Vous pincez les lèvres. Peut-être qu\'il ira mieux tout seul, mais il ne sera pas en état de se battre s\'il ne reçoit pas de soins. | %woundedbrother% n\'est plus en état de se battre. Ses blessures se sont infectées. Sans soins immédiats, il risque de mettre du temps à retrouver la forme. | %woundedbrother% entre en titubant dans votre tente. Il tousse dans le creux de son coude et un peu de salive filandreuse traîne entre celui-ci et ses lèvres.%SPEECH_ON%Ah merde, désolé monsieur. Je suis euh, je crois que je suis un peu malade. %SPEECH_OFF%En l\'examinant, vous supposez que ses blessures se sont infectées. Il est peut-être encore capable de se battre, mais vous ne devriez probablement pas prendre ce risque avant qu\'il n\'aille mieux. | Alors que la compagnie mange autour d\'un feu de camp, %woundedbrother% vomit soudainement. On voit qu\'il a de la sueur sur le front et que ses yeux sont un peu hébétés. %otherbrother% secoue la tête. %SPEECH_ON%Capitaine, ses blessures se sont infectées. %SPEECH_OFF%Le frère blessé retourne dans l\'herbe, les bras en l\'air. %SPEECH_ON% Je vais bien, les gars. Je vais me battre contre vous tous. Ses poings en boule vont et viennent avant de glisser dans un profond sommeil. Ouais, il ne sera probablement pas prêt pour le combat avant un moment. | Les batailles mettent les hommes à rude épreuve, et parfois ils survivent à des blessures qui reviennent les chercher. %woundedbrother% est un tel homme - l\'infection due aux blessures s\'est répandue sur son corps. Il est très malade et ne devrait pas se battre sauf en cas de nécessité absolue. | Avec chaque bataille, un homme risque la mort. Avec chaque blessure, il risque l\'infection. %woundedbrother% a reçu la seconde et cela pourrait bien empêcher la première. Ses blessures sont devenues noires et là où elles ne sont pas noires, elles sont vertes. Il est capable de marcher, mais devrait probablement être tenu à l\'écart des lignes de front jusqu\'à ce qu\'il aille mieux. | Un homme peut survivre à une bataille avec de terribles blessures, mais cela ne fait que commencer une autre bataille contre l\'infection. Les blessures de %woundedbrother% ont empiré et peuvent avoir besoin de temps pour guérir. À moins d\'une nécessité absolue, il devrait être tenu à l\'écart des lignes de front. | Les blessures de %woundedbrother% ont empiré et sont probablement infectées. Certains suggèrent des asticots pour aider à éliminer l\'infection, tandis que d\'autres évoquent des amputations et des mesures plus drastiques. En ce qui vous concerne, vous devez simplement lui donner du temps. Cela dit, le mercenaire devrait probablement être tenu à l\'écart des combats jusqu\'à ce qu\'il aille mieux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{J\'espère que tu t\'en sortiras. | Ça n\'a pas l\'air bon. | Va te reposer, %woundedbrothershort%.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury([
					{
						ID = "injury.infection",
						Threshold = 0.25,
						Script = "injury/infected_wound_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " souffre de " + injury.getNameOnly()
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			local injuries = bro.getSkills().query(this.Const.SkillType.TemporaryInjury);
			local next = false;

			foreach( inj in injuries )
			{
				if (inj.getID() == "injury.infection")
				{
					next = true;
					break;
				}
			}

			if (next)
			{
				continue;
			}

			foreach( inj in injuries )
			{
				if (!inj.isTreated() && inj.getInfectionChance() != 0)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.Other = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.Other.getID() == this.m.Injured.getID());

		this.m.Score = candidates.len() * 7;
	}

	function onPrepare()
	{
		local injuries = this.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
		local wound;
		local highest = -1.0;

		foreach( inj in injuries )
		{
			if (!inj.isTreated() && inj.getInfectionChance() > highest)
			{
				wound = inj;
				highest = inj.getInfectionChance();
			}
		}

		this.m.WoundName = wound.getNameOnly().tolower();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wound",
			this.m.WoundName
		]);
		_vars.push([
			"woundedbrother",
			this.m.Injured.getName()
		]);
		_vars.push([
			"woundedbrothershort",
			this.m.Injured.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
		this.m.Other = null;
		this.m.WoundName = "";
	}

});

